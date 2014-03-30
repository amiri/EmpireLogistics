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
    $c->response->body('Page not found');
    $c->response->status(404);
}

sub end : ActionClass('RenderView') { }

__PACKAGE__->meta->make_immutable;

1;
