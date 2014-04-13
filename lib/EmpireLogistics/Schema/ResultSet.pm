package EmpireLogistics::Schema::ResultSet;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::ResultSet';

sub BUILDARGS { $_[2] }

__PACKAGE__->meta->make_immutable;

1;

