package EmpireLogistics::Schema::Result::RawRailLine;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

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




__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_resultsource}->name,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_resultsource}->name,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

__PACKAGE__->meta->make_immutable;
1;
