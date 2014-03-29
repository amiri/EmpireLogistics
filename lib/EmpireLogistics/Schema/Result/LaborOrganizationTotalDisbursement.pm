package EmpireLogistics::Schema::Result::LaborOrganizationTotalDisbursement;



use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("labor_organization_total_disbursement");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_total_disbursement_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.219132+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.219132+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "labor_organization",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "year",
  { data_type => "integer", is_nullable => 0 },
  "administration",
  { data_type => "integer", is_nullable => 1 },
  "affiliates",
  { data_type => "integer", is_nullable => 1 },
  "benefits",
  { data_type => "integer", is_nullable => 1 },
  "contributions",
  { data_type => "integer", is_nullable => 1 },
  "education",
  { data_type => "integer", is_nullable => 1 },
  "employee_salaries",
  { data_type => "integer", is_nullable => 1 },
  "employees_total",
  { data_type => "integer", is_nullable => 1 },
  "fees",
  { data_type => "integer", is_nullable => 1 },
  "general_overhead",
  { data_type => "integer", is_nullable => 1 },
  "investments",
  { data_type => "integer", is_nullable => 1 },
  "loans_made",
  { data_type => "integer", is_nullable => 1 },
  "loans_paid",
  { data_type => "integer", is_nullable => 1 },
  "members",
  { data_type => "integer", is_nullable => 1 },
  "officer_administration",
  { data_type => "integer", is_nullable => 1 },
  "officer_salaries",
  { data_type => "integer", is_nullable => 1 },
  "officers_total",
  { data_type => "integer", is_nullable => 1 },
  "office_supplies",
  { data_type => "integer", is_nullable => 1 },
  "other",
  { data_type => "integer", is_nullable => 1 },
  "other_contributions",
  { data_type => "integer", is_nullable => 1 },
  "other_general_overhead",
  { data_type => "integer", is_nullable => 1 },
  "other_political",
  { data_type => "integer", is_nullable => 1 },
  "other_representation",
  { data_type => "integer", is_nullable => 1 },
  "other_union_administration",
  { data_type => "integer", is_nullable => 1 },
  "per_capita_tax",
  { data_type => "integer", is_nullable => 1 },
  "political",
  { data_type => "integer", is_nullable => 1 },
  "professional_services",
  { data_type => "integer", is_nullable => 1 },
  "representation",
  { data_type => "integer", is_nullable => 1 },
  "strike_benefits",
  { data_type => "integer", is_nullable => 1 },
  "taxes",
  { data_type => "integer", is_nullable => 1 },
  "union_administration",
  { data_type => "integer", is_nullable => 1 },
  "withheld",
  { data_type => "integer", is_nullable => 1 },
  "withheld_not_disbursed",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_organization_total_disburseme_labor_organization_year_key",
  ["labor_organization", "year"],
);
__PACKAGE__->belongs_to(
  "labor_organization",
  "EmpireLogistics::Schema::Result::LaborOrganization",
  { id => "labor_organization" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);




__PACKAGE__->meta->make_immutable;
1;
