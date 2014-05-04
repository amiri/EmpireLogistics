package EmpireLogistics::Schema::ResultSet::LaborOrganization;

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
        id                  => 'ID',
        create_time         => 'Create Time',
        update_time         => 'Update Time',
        delete_time         => 'Deleted',
        name                => "Name",
        usdol_filing_number => 'US Dept. of Labor Filing Number',
        abbreviation        => 'Abbreviation',
        date_established    => 'Date Established',
        url                 => 'URL',
        organization_type   => 'Type',
        local_prefix        => 'Local Prefix',
        local_suffix        => 'Local Suffix',
        local_type          => 'Local Type',
        local_number        => 'Local Number',
        description         => 'Description',
    };
}

__PACKAGE__->meta->make_immutable;

1;

