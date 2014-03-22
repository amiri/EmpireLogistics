use utf8;
package EmpireLogistics::Schema::Result::RailNode;

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
__PACKAGE__->table("rail_node");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_node_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:39.877002+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:39.877002+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "junction_id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "incident_links",
  { data_type => "integer", is_nullable => 1 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "geometry",
  { data_type => "geometry", is_nullable => 1, size => "12544,3519" },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "company_rail_nodes",
  "EmpireLogistics::Schema::Result::CompanyRailNode",
  { "foreign.rail_node" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_rail_nodes",
  "EmpireLogistics::Schema::Result::LaborOrganizationRailNode",
  { "foreign.rail_node" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "rail_node_work_stoppages",
  "EmpireLogistics::Schema::Result::RailNodeWorkStoppage",
  { "foreign.rail_node" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yyDvoHji8XanFN7gUmneZA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
