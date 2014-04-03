package EmpireLogistics::Web::Controller::Admin;

use Moose;
use MooseX::MethodAttributes;
use EmpireLogistics::Config;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' };

sub auto :Private {
    my ($self,$c) = @_;
    $c->check_user_roles(qw/admin/) or $c->detach(qw/Controller::Root access_denied/);
}

sub base :Chained('/') PathPart('admin') CaptureArgs(0) {
    my ($self,$c) = @_;
}

sub get_index :Chained('base') PathPart('') Args(0) GET {
    my ($self,$c) = @_;
    $c->stash->{template} = 'admin/index.tt';
}

__PACKAGE__->meta->make_immutable;

1;
