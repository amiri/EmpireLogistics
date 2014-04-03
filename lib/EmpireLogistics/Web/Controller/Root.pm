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
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{tiles_url} = $EmpireLogistics::Config::tiles_url;
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
