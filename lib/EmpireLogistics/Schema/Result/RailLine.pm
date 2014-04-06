package EmpireLogistics::Schema::Result::RailLine;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("rail_line");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_line_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.770132+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.770132+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "link_id",
  { data_type => "text", is_nullable => 1 },
  "route_id",
  { data_type => "text", is_nullable => 1 },
  "miles",
  { data_type => "double precision", is_nullable => 1 },
  "direction",
  { data_type => "text", is_nullable => 1 },
  "track_type",
  { data_type => "text", is_nullable => 1 },
  "grade",
  { data_type => "text", is_nullable => 1 },
  "gauge",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
  "passenger",
  { data_type => "text", is_nullable => 1 },
  "military_subsystem",
  { data_type => "text", is_nullable => 1 },
  "signal_system",
  { data_type => "text", is_nullable => 1 },
  "traffic_density",
  { data_type => "text", is_nullable => 1 },
  "line_class",
  { data_type => "text", is_nullable => 1 },
  "a_junction",
  { data_type => "text", is_nullable => 1 },
  "b_junction",
  { data_type => "text", is_nullable => 1 },
  "subdivision",
  { data_type => "text", is_nullable => 1 },
  "owner1",
  { data_type => "text", is_nullable => 1 },
  "owner2",
  { data_type => "text", is_nullable => 1 },
  "trackage_rights1",
  { data_type => "text", is_nullable => 1 },
  "trackage_rights2",
  { data_type => "text", is_nullable => 1 },
  "trackage_rights3",
  { data_type => "text", is_nullable => 1 },
  "geometry",
  { data_type => "geometry", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "rail_line_work_stoppages",
  "EmpireLogistics::Schema::Result::RailLineWorkStoppage",
  { "foreign.rail_line" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);




__PACKAGE__->meta->make_immutable;
1;
