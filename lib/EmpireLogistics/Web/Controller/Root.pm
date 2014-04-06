package EmpireLogistics::Web::Controller::Root;

use Moose;
use EmpireLogistics::Config;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config( namespace => '' );

sub auto : Private {
    my ( $self, $c ) = @_;
    $c->stash( use_wrapper => 1 ) unless $c->req->is_xhr;
    my $locale = $c->req->param('locale');
    $c->response->headers->push_header( 'Vary' => 'Accept-Language' );
    $c->language( $locale ? [$locale] : undef );
    $c->forward('check_authentication');
}

sub index : Path : Args(0) GET {
    my ( $self, $c ) = @_;
    $c->stash->{tiles_url} = $EmpireLogistics::Config::tiles_url;
}

sub post_update_map_location :Chained('/') PathPart('update_map_location') Args(0) POST {
    my ($self,$c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    my $hash = $c->req->param('hash');
    $c->user_session->{hash_location} = $hash;
    return 1;
}

sub default : Path {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'error_404.tt';
    $c->response->status(404);
}

sub access_denied : Private {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'error_401.tt';
    $c->response->status(401);
}

sub check_authentication :Private {
    my ($self,$c) = @_;
    # Try to login the user via the login cookie
    my $login_cookie = $c->request->cookie('login');
    if ($login_cookie && !$c->user_exists) {
        my $id =
            EmpireLogistics::Schema::Result::User->id_from_login_cookie($login_cookie->value);
        $c->authenticate({ id => $id }, 'no_password')
            if ($id);
    }
    return 1;
}

sub render : ActionClass('RenderView') { }

sub end : Private {
    my ( $self, $c ) = @_;
    if ( scalar( @{ $c->error } ) and not $c->debug ) {
        $c->stash->{errors} = $c->error;
        $c->log->error($_) for ( @{ $c->error } );
        $c->response->status(500);
        $c->stash->{template} = 'error_500.tt';
        $c->clear_errors;
    }
    $c->forward('/render') or return;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
