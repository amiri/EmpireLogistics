package EmpireLogistics::Schema::Result::RasterColumn;



use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table_class("DBIx::Class::ResultSource::View");
__PACKAGE__->table("raster_columns");
__PACKAGE__->add_columns(
  "r_table_catalog",
  { data_type => "name", is_nullable => 1, size => 64 },
  "r_table_schema",
  { data_type => "name", is_nullable => 1, size => 64 },
  "r_table_name",
  { data_type => "name", is_nullable => 1, size => 64 },
  "r_raster_column",
  { data_type => "name", is_nullable => 1, size => 64 },
  "srid",
  { data_type => "integer", is_nullable => 1 },
  "scale_x",
  { data_type => "double precision", is_nullable => 1 },
  "scale_y",
  { data_type => "double precision", is_nullable => 1 },
  "blocksize_x",
  { data_type => "integer", is_nullable => 1 },
  "blocksize_y",
  { data_type => "integer", is_nullable => 1 },
  "same_alignment",
  { data_type => "boolean", is_nullable => 1 },
  "regular_blocking",
  { data_type => "boolean", is_nullable => 1 },
  "num_bands",
  { data_type => "integer", is_nullable => 1 },
  "pixel_types",
  { data_type => "text[]", is_nullable => 1 },
  "nodata_values",
  { data_type => "double precision[]", is_nullable => 1 },
  "out_db",
  { data_type => "boolean[]", is_nullable => 1 },
  "extent",
  { data_type => "geometry", is_nullable => 1 },
);




__PACKAGE__->meta->make_immutable;
1;
