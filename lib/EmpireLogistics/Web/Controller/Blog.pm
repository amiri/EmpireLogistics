package EmpireLogistics::Web::Controller::Blog;

use Moose;
use MooseX::MethodAttributes;
use namespace::autoclean;
extends 'Catalyst::Controller';

sub base :Chained('/') PathPart('blog') CaptureArgs(0) GET {
    my ($self,$c) = @_;
}

sub all :Chained('base') PathPart('') Args(0) GET {
    my ($self, $c) = @_;
}

sub year :Chained('base') PathPart('') Args(1) GET {
    my ($self, $c, $year) = @_;
}

sub month :Chained('base') PathPart('') Args(2) GET {
    my ($self, $c, $year, $month) = @_;
}

sub day :Chained('base') PathPart('') Args(3) GET {
    my ($self, $c, $year, $month, $day) = @_;
}

sub single :Chained('base') PathPart('') Args(4) GET {
    my ($self, $c, $year, $month, $day, $title) = @_;
}


__PACKAGE__->meta->make_immutable;

1;
