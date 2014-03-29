package EmpireLogistics::Schema::Result::LaborLocalMember;



use Moose;
extends 'EmpireLogistics::Schema::Result';
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "TimeStamp",
  "InflateColumn::DateTime::Duration",
);
__PACKAGE__->table("labor_local_members");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_local_members_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.429757+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.429757+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "labor_local",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "year",
  { data_type => "integer", is_nullable => 0 },
  "members",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_local_members_labor_local_year_key",
  ["labor_local", "year"],
);
__PACKAGE__->belongs_to(
  "labor_local",
  "EmpireLogistics::Schema::Result::LaborLocal",
  { id => "labor_local" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);




__PACKAGE__->meta->make_immutable;
1;
