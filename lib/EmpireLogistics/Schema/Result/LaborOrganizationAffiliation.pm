package EmpireLogistics::Schema::Result::LaborOrganizationAffiliation;



use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("labor_organization_affiliation");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_affiliation_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.17708+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.17708+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "child",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "parent",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "year",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_organization_affiliation_child_parent_year_key",
  ["child", "parent", "year"],
);
__PACKAGE__->belongs_to(
  "child",
  "EmpireLogistics::Schema::Result::LaborOrganization",
  { id => "child" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "parent",
  "EmpireLogistics::Schema::Result::LaborOrganization",
  { id => "parent" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);




__PACKAGE__->meta->make_immutable;
1;
