use utf8;
package EmpireLogistics::Schema::Result::EditHistory;

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
__PACKAGE__->table("edit_history");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "edit_history_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.665894+00",
    is_nullable   => 0,
  },
  "object_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "object_type",
      list => [
        "address",
        "company",
        "company_address",
        "company_nlrb_decision",
        "company_osha_citation",
        "company_port",
        "company_rail_node",
        "company_warehouse",
        "labor_organization",
        "labor_organization_address",
        "labor_organization_nlrb_decision",
        "labor_organization_osha_citation",
        "labor_organization_port",
        "labor_organization_rail_node",
        "labor_organization_warehouse",
        "media",
        "nlrb_decision",
        "osha_citation",
        "port",
        "port_address",
        "port_depth_feet",
        "port_depth_meters",
        "port_drydock",
        "port_harbor_size",
        "port_harbor_type",
        "port_repair",
        "port_shelter",
        "port_tonnage",
        "port_vessel_size",
        "rail_density",
        "rail_interline",
        "rail_line",
        "rail_line_class",
        "rail_military",
        "rail_node",
        "rail_ownership",
        "rail_passenger",
        "rail_signal",
        "rail_status",
        "rail_subdivision",
        "rail_subdivision_state",
        "rail_track_gauge",
        "rail_track_grade",
        "rail_track_type",
        "state",
        "topology",
        "user",
        "walmart",
        "warehouse",
        "warehouse_address",
        "warehouse_type",
        "warehouse_walmart",
        "work_stoppage",
      ],
    },
    is_nullable => 0,
  },
  "object",
  { data_type => "integer", is_nullable => 0 },
  "user",
  { data_type => "integer", is_nullable => 0 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-03 01:14:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tKVB61+aEcRGnjIT03gX+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
