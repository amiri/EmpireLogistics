package EmpireLogistics::Web::View::JSON;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;
use JSON::XS ();
use feature qw/state/;
extends 'Catalyst::View::JSON';

sub encode_json {
    my ( $self, $c, $to_encode ) = @_;
    state $encoder = JSON::XS->new->utf8->pretty(1)->convert_blessed(1)->allow_nonref(1);
    $encoder->encode($to_encode);
}

after 'process' => sub {
    my $self = shift;
    my $c    = shift;
    if ( $c->req->user_agent =~ /MSIE/ ) {
        $c->response->headers->header( 'Content-Type' => 'text/html' );
        $c->response->headers->header(
            'X-Content-Type-Options' => 'nosniff' );
    }
};

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
