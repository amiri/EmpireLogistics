package EmpireLogistics::Schema::ResultSet;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::ResultSet';

sub BUILDARGS { $_[2] }

sub active {
    my $self = shift;
    return $self->search({delete_time => undef});
}

__PACKAGE__->meta->make_immutable;

1;

