package EmpireLogistics::Schema::ResultSet::RailInterline;

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
        id                    => 'ID',
        create_time           => 'Create Time',
        update_time           => 'Update Time',
        delete_time           => 'Deleted',
        interline_id_number   => 'Interline ID',
        forwarding_node       => 'Forwarding Node',
        receiving_node        => 'Receiving Node',
        forwarding_node_owner => 'Forwarding Node Owner',
        receiving_node_owner  => 'Receiving Node Owner',
        junction_code         => 'Junction Code',
        impedance             => 'Impedance (cost of use)',
        geometry              => 'Geometry',
        description           => 'Description',
    };
}

__PACKAGE__->meta->make_immutable;

1;
