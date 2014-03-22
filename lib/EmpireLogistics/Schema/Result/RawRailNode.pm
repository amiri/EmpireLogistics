use utf8;
package EmpireLogistics::Schema::Result::RawRailNode;

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
__PACKAGE__->table("raw_rail_node");
__PACKAGE__->add_columns(
  "gid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "raw_rail_node_gid_seq",
  },
  "jid",
  { data_type => "integer", is_nullable => 1 },
  "jturn",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "astate",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "jname",
  { data_type => "varchar", is_nullable => 1, size => 24 },
  "incid",
  { data_type => "smallint", is_nullable => 1 },
  "splc",
  { data_type => "varchar", is_nullable => 1, size => 6 },
  "geom",
  { data_type => "geometry", is_nullable => 1, size => "12544,3519" },
);
__PACKAGE__->set_primary_key("gid");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Gi3hAoXZplYr8wH0NJUWNg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
