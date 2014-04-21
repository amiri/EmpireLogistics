package EmpireLogistics::Schema::ResultSet::Warehouse;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'EmpireLogistics::Schema::ResultSet';

sub BUILDARGS { $_[2] }

has 'labels' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_labels',
);

sub _build_labels {
    my $self = shift;
    return {
        create_time => 'Create Time',
        delete_time => 'Deleted',
        description => 'Description',
        geometry    => "Geometry",
        area        => 'Area (square feet)',
        id          => 'ID',
        latitude    => "Latitude",
        longitude   => "Longitude",
        name        => "Warehouse Name",
        owner       => 'Owner',
        status      => 'Status',
        update_time => 'Update Time',
        date_opened => 'Date Opened',
    };
}

__PACKAGE__->meta->make_immutable;

1;

