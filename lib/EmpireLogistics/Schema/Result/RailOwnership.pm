package EmpireLogistics::Schema::Result::RailOwnership;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("rail_ownership");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_ownership_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.800851+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.800851+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "aar_code",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "family",
  { data_type => "text", is_nullable => 1 },
  "history",
  { data_type => "text", is_nullable => 1 },
  "flag",
  { data_type => "text", is_nullable => 1 },
  "reporting_mark",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");




__PACKAGE__->meta->make_immutable;
1;
