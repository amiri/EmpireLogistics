package EmpireLogistics::Schema::Result::GeographyColumn;



use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table_class("DBIx::Class::ResultSource::View");
__PACKAGE__->table("geography_columns");
__PACKAGE__->add_columns(
  "f_table_catalog",
  { data_type => "name", is_nullable => 1, size => 64 },
  "f_table_schema",
  { data_type => "name", is_nullable => 1, size => 64 },
  "f_table_name",
  { data_type => "name", is_nullable => 1, size => 64 },
  "f_geography_column",
  { data_type => "name", is_nullable => 1, size => 64 },
  "coord_dimension",
  { data_type => "integer", is_nullable => 1 },
  "srid",
  { data_type => "integer", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
);




__PACKAGE__->meta->make_immutable;
1;
