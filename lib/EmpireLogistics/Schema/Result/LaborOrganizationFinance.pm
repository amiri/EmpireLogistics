use utf8;
package EmpireLogistics::Schema::Result::LaborOrganizationFinance;

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
__PACKAGE__->table("labor_organization_finances");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_finances_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.417141+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.417141+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "labor_organization",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "year",
  { data_type => "integer", is_nullable => 0 },
  "assets",
  { data_type => "integer", is_nullable => 1 },
  "liabilities",
  { data_type => "integer", is_nullable => 1 },
  "total_income",
  { data_type => "integer", is_nullable => 1 },
  "representation_expenses",
  { data_type => "integer", is_nullable => 1 },
  "political_expenses",
  { data_type => "integer", is_nullable => 1 },
  "gifts_expenses",
  { data_type => "integer", is_nullable => 1 },
  "general_overhead_expenses",
  { data_type => "integer", is_nullable => 1 },
  "union_administration_expenses",
  { data_type => "integer", is_nullable => 1 },
  "strike_benefits_expenses",
  { data_type => "integer", is_nullable => 1 },
  "officer_salary_expenses",
  { data_type => "integer", is_nullable => 1 },
  "employee_salary_expenses",
  { data_type => "integer", is_nullable => 1 },
  "education_expenses",
  { data_type => "integer", is_nullable => 1 },
  "total_expenses",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_organization_finances_labor_organization_year_key",
  ["labor_organization", "year"],
);
__PACKAGE__->belongs_to(
  "labor_organization",
  "EmpireLogistics::Schema::Result::LaborOrganization",
  { id => "labor_organization" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-03 01:14:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oyDaX3yeZK4Ti0W7CVlKNA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;