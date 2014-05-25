package EmpireLogistics::Schema::ResultSet::Country;

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
        id                  => "ID",
        create_time         => "Create Time",
        update_time         => "Update Time",
        delete_time         => "Deleted",
        name                => "Country Name",
        official_name       => "Official Name",
        official_name_ascii => "Official Name (ASCII)",
        iso_alpha2          => "ISO Alpha 2",
        iso_alpha3          => "ISO Alpha 3",
        iso_id              => "ISO ID",
        fips_code           => "FIPS Code",
        area_kilometers     => "Area (km)",
        population          => "Population",
        continent           => "Continent",
        tld                 => "Top-level Domain",
        currency            => "Currency",
        phone               => "Phone",
        postal              => "Postal",
        postalregex         => "Postal Regex",
        languages           => "Languages",
        geonameid           => "Geoname ID",
        neighbours          => "Neighbors",
        alternate_names     => "Alternate Names",
    };
}

__PACKAGE__->meta->make_immutable;

1;
