package EmpireLogistics::Schema::Result::RailSubdivision;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("rail_subdivision");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_subdivision_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "full_name",
  { data_type => "text", is_nullable => 1 },
  "wmark",
  { data_type => "text", is_nullable => 1 },
  "subdivision_type",
  { data_type => "text", is_nullable => 1 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "rail_subdivision_states",
  "EmpireLogistics::Schema::Result::RailSubdivisionState",
  { "foreign.subdivision" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);




__PACKAGE__->meta->make_immutable;
1;
