package EmpireLogistics::Schema::Result::RailInterline;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("rail_interline");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_interline_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.779911+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.779911+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "interline_id_number",
  { data_type => "integer", is_nullable => 1 },
  "forwarding_node",
  { data_type => "text", is_nullable => 1 },
  "receiving_node",
  { data_type => "text", is_nullable => 1 },
  "forwarding_node_owner",
  { data_type => "text", is_nullable => 1 },
  "receiving_node_owner",
  { data_type => "text", is_nullable => 1 },
  "junction_code",
  { data_type => "text", is_nullable => 1 },
  "impedance",
  { data_type => "integer", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "geometry",
  { data_type => "geometry", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");




__PACKAGE__->meta->make_immutable;
1;
