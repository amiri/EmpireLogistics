package EmpireLogistics::Schema::Result;


use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "FilterColumn",
  "EncodedColumn",
  "InflateColumn::DateTime",
  "TimeStamp",
  "InflateColumn::DateTime::Duration",
  "Helper::Row::ToJSON",
  "Core",
);

__PACKAGE__->meta->make_immutable;

1;
