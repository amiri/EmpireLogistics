use utf8;
package EmpireLogistics::Schema::Result::LaborOrganizationGeneralDisbursement;

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
    default_value => "2014-03-22 19:27:40.597255+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.597255+00",
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


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wXToEY0irlx8V5P+rLXfZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
