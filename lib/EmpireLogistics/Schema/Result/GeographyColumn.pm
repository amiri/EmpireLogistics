use utf8;
package EmpireLogistics::Schema::Result::GeographyColumn;

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


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-03 01:14:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3lIjrTFWczTVGzNLrvYTUA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
