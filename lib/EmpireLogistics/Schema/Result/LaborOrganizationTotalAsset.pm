use utf8;
package EmpireLogistics::Schema::Result::LaborOrganizationTotalAsset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "TimeStamp",
  "InflateColumn::DateTime::Duration",
);
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
    default_value => "2014-03-22 19:27:40.478036+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.478036+00",
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


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s666AgHobkTgu057VSmCVQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
