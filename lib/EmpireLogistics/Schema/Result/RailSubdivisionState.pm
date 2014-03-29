package EmpireLogistics::Schema::Result::RailSubdivisionState;



use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("rail_subdivision_state");
__PACKAGE__->add_columns(
  "subdivision",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "state",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.844684+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:06.844684+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("subdivision", "state");
__PACKAGE__->belongs_to(
  "state",
  "EmpireLogistics::Schema::Result::State",
  { id => "state" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "subdivision",
  "EmpireLogistics::Schema::Result::RailSubdivision",
  { id => "subdivision" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);




__PACKAGE__->meta->make_immutable;
1;
