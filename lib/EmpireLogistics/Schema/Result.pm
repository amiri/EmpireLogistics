package EmpireLogistics::Schema::Result;


use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "TimeStamp",
  "InflateColumn::DateTime::Duration",
  "EncodedColumn",
);

__PACKAGE__->meta->make_immutable;

1;
