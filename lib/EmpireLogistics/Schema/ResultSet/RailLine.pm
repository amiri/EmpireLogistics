package EmpireLogistics::Schema::ResultSet::RailLine;

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
        id                 => 'ID',
        create_time        => 'Create Time',
        update_time        => 'Update Time',
        delete_time        => 'Deleted',
        link_id            => 'Link ID',
        route_id           => 'Route ID',
        miles              => 'Miles',
        direction          => 'Direction',
        track_type         => 'Track Type',
        grade              => 'Grade',
        gauge              => 'Gauge',
        status             => 'Status',
        passenger          => 'Passenger?',
        military_subsystem => 'Military Subsystem',
        signal_system      => 'Signal System',
        traffic_density    => 'Traffic Density',
        line_class         => 'Line Class',
        a_junction         => 'A Junction',
        b_junction         => 'B Junction',
        subdivision        => 'Subdivision',
        owner1             => 'Owner 1',
        owner2             => 'Owner 2',
        trackage_rights1   => 'Trackage Rights 1',
        trackage_rights2   => 'Trackage Rights 2',
        trackage_rights3   => 'Trackage Rights 3',
        geometry           => "Geometry",
    };
}

__PACKAGE__->meta->make_immutable;

1;
