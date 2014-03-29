package EmpireLogistics::Schema::Result::LaborOrganizationGeneralDisbursement;



use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("labor_organization_general_disbursement");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_general_disbursement_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.466283+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.466283+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "labor_organization",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "year",
  { data_type => "integer", is_nullable => 0 },
  "amount",
  { data_type => "integer", is_nullable => 1 },
  "disbursement_date",
  { data_type => "date", is_nullable => 1 },
  "disbursement_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "disbursement_type",
      list => [
        "representation",
        "political",
        "contributions",
        "overhead",
        "administration",
        "general",
        "non-itemized",
        "other",
      ],
    },
    is_nullable => 1,
  },
  "payee",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "purpose",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_organization_general_di_labor_organization_year_amoun_key",
  [
    "labor_organization",
    "year",
    "amount",
    "disbursement_date",
    "payee",
    "purpose",
  ],
);
__PACKAGE__->belongs_to(
  "labor_organization",
  "EmpireLogistics::Schema::Result::LaborOrganization",
  { id => "labor_organization" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "payee",
  "EmpireLogistics::Schema::Result::LaborOrganizationPayee",
  { id => "payee" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);




__PACKAGE__->meta->make_immutable;
1;
