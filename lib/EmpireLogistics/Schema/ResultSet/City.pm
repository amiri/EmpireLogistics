package EmpireLogistics::Schema::ResultSet::City;

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
        id              => "ID",
        create_time     => "Create Time",
        update_time     => "Update Time",
        delete_time     => "Deleted",
        name            => "Country Name",
        name_ascii      => "Name (ASCII)",
        geonameid       => "Geoname ID",
        alternate_names => "Alternate Names",
        latitude        => "Latitude",
        longitude       => "Longitude",
        country         => "Country",
        admin1          => "Admin 1",
        admin2          => "Admin 2",
        admin3          => "Admin 3",
        admin4          => "Admin 4",
        fcode           => "Feature Code",
        state           => "State",
        population      => "Population",
        timezone        => "Timezone",
        geometry        => "Geometry",
    };
}

__PACKAGE__->meta->make_immutable;

1;

