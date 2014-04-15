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




__PACKAGE__->belongs_to(
    "object_type" =>
    "EmpireLogistics::Schema::Result::ObjectType",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.name " => { -ident => "$args->{self_resultsource}.name" },
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.name" => $args->{self_resultsource}->name,
            },
        );
    },
);

__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

__PACKAGE__->meta->make_immutable;
1;
