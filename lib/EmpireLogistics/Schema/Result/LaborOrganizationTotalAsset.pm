package EmpireLogistics::Schema::Result::LaborOrganizationTotalAsset;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("labor_organization_total_asset");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_total_asset_id_seq",
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
  "accounts_receivable_end",
  { data_type => "integer", is_nullable => 1 },
  "accounts_receivable_start",
  { data_type => "integer", is_nullable => 1 },
  "cash_end",
  { data_type => "integer", is_nullable => 1 },
  "cash_start",
  { data_type => "integer", is_nullable => 1 },
  "fixed_assets_end",
  { data_type => "integer", is_nullable => 1 },
  "fixed_assets_start",
  { data_type => "integer", is_nullable => 1 },
  "investments_end",
  { data_type => "integer", is_nullable => 1 },
  "investments_start",
  { data_type => "integer", is_nullable => 1 },
  "loans_receivable_end",
  { data_type => "integer", is_nullable => 1 },
  "loans_receivable_start",
  { data_type => "integer", is_nullable => 1 },
  "other_assets_end",
  { data_type => "integer", is_nullable => 1 },
  "other_assets_start",
  { data_type => "integer", is_nullable => 1 },
  "other_investments_book_value",
  { data_type => "integer", is_nullable => 1 },
  "other_investments_cost",
  { data_type => "integer", is_nullable => 1 },
  "securities_book_value",
  { data_type => "integer", is_nullable => 1 },
  "securities_cost",
  { data_type => "integer", is_nullable => 1 },
  "total_start",
  { data_type => "integer", is_nullable => 1 },
  "treasuries_end",
  { data_type => "integer", is_nullable => 1 },
  "treasuries_start",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_organization_total_asset_labor_organization_year_key",
  ["labor_organization", "year"],
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
