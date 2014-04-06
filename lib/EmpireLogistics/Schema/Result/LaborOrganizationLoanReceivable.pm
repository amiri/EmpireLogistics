package EmpireLogistics::Schema::Result::LaborOrganizationLoanReceivable;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("labor_organization_loan_receivable");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_loan_receivable_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.390907+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.390907+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "labor_organization",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "year",
  { data_type => "integer", is_nullable => 0 },
  "cash_repayments",
  { data_type => "integer", is_nullable => 1 },
  "loan_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "loan_type",
      list => ["itemized", "non-itemized", "other"],
    },
    is_nullable => 1,
  },
  "name",
  { data_type => "text", is_nullable => 1 },
  "new_loan_amount",
  { data_type => "integer", is_nullable => 1 },
  "non_cash_repayments",
  { data_type => "integer", is_nullable => 1 },
  "outstanding_end_amount",
  { data_type => "integer", is_nullable => 1 },
  "outstanding_start_amount",
  { data_type => "integer", is_nullable => 1 },
  "purpose",
  { data_type => "text", is_nullable => 1 },
  "security",
  { data_type => "text", is_nullable => 1 },
  "terms",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_organization_loan_recei_labor_organization_year_name__key",
  [
    "labor_organization",
    "year",
    "name",
    "new_loan_amount",
    "non_cash_repayments",
    "outstanding_end_amount",
    "outstanding_start_amount",
    "purpose",
    "security",
    "terms",
  ],
);
__PACKAGE__->belongs_to(
  "labor_organization",
  "EmpireLogistics::Schema::Result::LaborOrganization",
  { id => "labor_organization" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);




__PACKAGE__->meta->make_immutable;
1;
