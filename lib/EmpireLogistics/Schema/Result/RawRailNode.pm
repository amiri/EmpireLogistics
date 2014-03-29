package EmpireLogistics::Schema::Result::RawRailNode;



use Moose;
extends 'EmpireLogistics::Schema::Result';

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




__PACKAGE__->meta->make_immutable;
1;
