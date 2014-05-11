package EmpireLogistics::Web::Controller::Details;

use Moose;
use MooseX::MethodAttributes;
use namespace::autoclean;
extends 'Catalyst::Controller';

has 'model_for_path' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {{
        'rail-line'      => 'RailLine',
        'rail-node'      => 'RailNode',
        'port'           => 'Port',
        'warehouse'      => 'Warehouse',
        'rail-interline' => 'RailInterline',
    }}
);

sub begin :Private {
    my ( $self, $c ) = @_;
    my $wrapper = $c->req->is_xhr ? 'modal-wrapper.tt' : 'wrapper.tt';
    $c->stash->{wrapper} = $wrapper;
}

sub base : Chained('/') PathPart('details') CaptureArgs(0) GET {
    my ($self, $c) = @_;
    $c->stash->{current_view} = 'TT';
    $c->log->warn("I am in base");
    return 1;
}

sub capture_model : Chained('base') PathPart('') CaptureArgs(1) GET {
    my ($self, $c, $path) = @_;
    $c->log->warn("I am in capture_model");

    $c->error("No path for model") unless $path;
    my $model = $self->model_for_path->{$path};
    $c->error("Invalid path for model") unless $model;
    my $rs       = $c->model("DB::$model");
    my $template = 'details/' . $path . '/list.tt';
    $c->stash->{rs}       = $rs;
    $c->stash->{path}       = $path;
    $c->stash->{template} = $template;
    return 1;
}

sub display_model : Chained('capture_model') PathPart('') Args(0) {
    my ($self,$c) = @_;
    my $objects = [$c->stash->{rs}->all];
    $c->stash->{objects} = $objects;
}

sub capture_object : Chained('capture_model') PathPart('') CaptureArgs(1) GET {
    my ($self, $c, $id) = @_;
    $c->log->warn("I am in capture_object");
    $c->error("No id for detail view") unless $id;
    my $object = $c->stash->{rs}->find($id);
    $c->error("No object for id $id") unless $object;
    my $template = 'details/' . $c->stash->{path} . '/display.tt';
    $c->stash->{object} = $object;
    $c->stash->{template} = $template;
    return 1;
}

sub display : Chained('capture_object') PathPart('') Args(0) GET {
    my ($self, $c) = @_;
    $c->log->warn("I am in display");
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;

