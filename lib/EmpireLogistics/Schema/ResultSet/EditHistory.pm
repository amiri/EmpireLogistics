package EmpireLogistics::Schema::ResultSet::EditHistory;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'EmpireLogistics::Schema::ResultSet';

sub BUILDARGS { $_[2] }

has 'header_labels' => (
    is => 'ro',
    isa => 'ArrayRef',
    lazy => 1,
    builder => '_build_header_labels',
);

sub _build_header_labels {
    my $self = shift;
    return [ 
        "Create Time",
        "Edited By",
        "Field",
        "Value",
        "Original",
    ];
}

__PACKAGE__->meta->make_immutable;

1;


