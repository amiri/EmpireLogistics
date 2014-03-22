use utf8;
package EmpireLogistics::Schema::Result::RawRailLine;

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
__PACKAGE__->table("raw_rail_line");
__PACKAGE__->add_columns(
  "gid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "raw_rail_line_gid_seq",
  },
  "alid",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "rtid",
  { data_type => "varchar", is_nullable => 1, size => 13 },
  "qaux",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "miles",
  { data_type => "double precision", is_nullable => 1 },
  "dirctn",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "entrk",
  { data_type => "double precision", is_nullable => 1 },
  "emlc",
  { data_type => "double precision", is_nullable => 1 },
  "mlc",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "trktyp",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "grade",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "gauge",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "status",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "pasngr",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "milit",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "signal",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "densty",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "lsrc",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "lupdat",
  { data_type => "varchar", is_nullable => 1, size => 1 },
  "ja",
  { data_type => "integer", is_nullable => 1 },
  "jb",
  { data_type => "integer", is_nullable => 1 },
  "sb",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "lineid",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "w1",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "w2",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "t1",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "t2",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "t3",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "old1",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "geom",
  { data_type => "geometry", is_nullable => 1, size => "12560,3519" },
);
__PACKAGE__->set_primary_key("gid");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BeIu3h9w80b24CB2VJ1mJA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
