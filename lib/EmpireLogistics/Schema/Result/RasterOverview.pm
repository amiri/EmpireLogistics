use utf8;
package EmpireLogistics::Schema::Result::RasterOverview;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "TimeStamp",
  "InflateColumn::DateTime::Duration",
);
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");
__PACKAGE__->table("raster_overviews");
__PACKAGE__->add_columns(
  "o_table_catalog",
  { data_type => "name", is_nullable => 1, size => 64 },
  "o_table_schema",
  { data_type => "name", is_nullable => 1, size => 64 },
  "o_table_name",
  { data_type => "name", is_nullable => 1, size => 64 },
  "o_raster_column",
  { data_type => "name", is_nullable => 1, size => 64 },
  "r_table_catalog",
  { data_type => "name", is_nullable => 1, size => 64 },
  "r_table_schema",
  { data_type => "name", is_nullable => 1, size => 64 },
  "r_table_name",
  { data_type => "name", is_nullable => 1, size => 64 },
  "r_raster_column",
  { data_type => "name", is_nullable => 1, size => 64 },
  "overview_factor",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NYwlXetapH7VApue6Aj0EQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
