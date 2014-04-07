package EmpireLogistics::Web;

use Moose;
use CatalystX::RoleApplicator;
use EmpireLogistics::Config;
use URI;
use namespace::autoclean;

use Catalyst::Runtime 5.90;

use Catalyst;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config( %{$EmpireLogistics::Config::catalyst}, );
__PACKAGE__->apply_request_class_roles(
    qw/Catalyst::TraitFor::Request::XMLHttpRequest/);

__PACKAGE__->setup( @{$EmpireLogistics::Config::app_plugins} );

around authenticate => sub {
    my ( $orig, $c ) = ( shift, shift );
    my ($args) = @_;

    my $remember = delete $args->{remember};

    my $user = $c->$orig(@_);

    # Store a login cookie for the user
    # if they've clicked "Remember me"
    if ( $user && $remember ) {
        $c->response->cookies->{login} = {
            value   => $user->encrypted_login_cookie,
            expires => '+36M',
        };
    }

    return $user;
};

around logout => sub {
    my ( $orig, $c ) = ( shift, shift );

    $c->expire_cookie('login');
    my $return = $c->$orig(@_);
    return $return;
};

sub expire_cookie {
    my ( $c, $cookie_name ) = @_;
    return unless $c->req->cookies->{$cookie_name};
    $c->res->cookies->{$cookie_name} = {
        value   => $c->req->cookies->{$cookie_name}->value(),
        expires => '-1d',
    };
    return 1;
}

sub build_backref {
    my $c = shift;
    return $c->uri_for(URI->new('/'.$c->req->path));
}

__PACKAGE__->meta->make_immutable;

1;
