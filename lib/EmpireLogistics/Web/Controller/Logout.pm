package EmpireLogistics::Web::Controller::Logout;

use Moose;
use MooseX::MethodAttributes;
use namespace::autoclean;
extends 'Catalyst::Controller';

sub base :Chained('/') PathPart('logout') CaptureArg(0) {
    my ($self,$c) = @_;
    $c->stash->{template} = 'logout.tt';
}

sub get_index : Chained('base') PathPart('') Args(0) GET {
    my ($self,$c) = @_;
    $c->logout;
    $c->redirect_and_detach('/');
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;

