use utf8;
package EmpireLogistics::Schema::Result::LaborOrganization;

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
__PACKAGE__->table("labor_organization");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.403941+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.403941+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "abbreviation",
  { data_type => "text", is_nullable => 1 },
  "date_established",
  { data_type => "date", is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "organization_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "labor_organization_type",
      list => ["federation", "union", "hybrid", "reform", "other"],
    },
    is_nullable => 1,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "labor_local_affiliations",
  "EmpireLogistics::Schema::Result::LaborLocalAffiliation",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_addresses",
  "EmpireLogistics::Schema::Result::LaborOrganizationAddress",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_affiliation_children",
  "EmpireLogistics::Schema::Result::LaborOrganizationAffiliation",
  { "foreign.child" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_affiliation_parents",
  "EmpireLogistics::Schema::Result::LaborOrganizationAffiliation",
  { "foreign.parent" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_finances",
  "EmpireLogistics::Schema::Result::LaborOrganizationFinance",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_members",
  "EmpireLogistics::Schema::Result::LaborOrganizationMember",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_nlrb_decisions",
  "EmpireLogistics::Schema::Result::LaborOrganizationNlrbDecision",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_osha_citations",
  "EmpireLogistics::Schema::Result::LaborOrganizationOshaCitation",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_ports",
  "EmpireLogistics::Schema::Result::LaborOrganizationPort",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_rail_nodes",
  "EmpireLogistics::Schema::Result::LaborOrganizationRailNode",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_warehouses",
  "EmpireLogistics::Schema::Result::LaborOrganizationWarehouse",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_work_stoppages",
  "EmpireLogistics::Schema::Result::LaborOrganizationWorkStoppage",
  { "foreign.labor_organization" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-03 01:14:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2tWrhpStlRqy/oZawBVdLA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
