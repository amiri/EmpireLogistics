package EmpireLogistics::Schema::Result::Port;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("port");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "port_id_seq",
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
  "port_name",
  { data_type => "text", is_nullable => 1 },
  "country",
  { data_type => "text", is_nullable => 1 },
  "harbor_size",
  { data_type => "text", is_nullable => 1 },
  "harbor_type",
  { data_type => "text", is_nullable => 1 },
  "shelter",
  { data_type => "text", is_nullable => 1 },
  "entry_tide_restriction",
  { data_type => "boolean", is_nullable => 1 },
  "entry_swell_restriction",
  { data_type => "boolean", is_nullable => 1 },
  "entry_ice_restriction",
  { data_type => "boolean", is_nullable => 1 },
  "entry_other_restriction",
  { data_type => "boolean", is_nullable => 1 },
  "overhead_limits",
  { data_type => "boolean", is_nullable => 1 },
  "channel_depth",
  { data_type => "text", is_nullable => 1 },
  "anchor_depth",
  { data_type => "text", is_nullable => 1 },
  "cargo_pier_depth",
  { data_type => "text", is_nullable => 1 },
  "oil_terminal_depth",
  { data_type => "text", is_nullable => 1 },
  "tide_range",
  { data_type => "integer", is_nullable => 1 },
  "max_vessel_size",
  { data_type => "text", is_nullable => 1 },
  "good_holding_ground",
  { data_type => "boolean", is_nullable => 1 },
  "turning_basin",
  { data_type => "boolean", is_nullable => 1 },
  "first_port_of_entry",
  { data_type => "boolean", is_nullable => 1 },
  "us_representative",
  { data_type => "boolean", is_nullable => 1 },
  "eta_message",
  { data_type => "boolean", is_nullable => 1 },
  "pilotage_required",
  { data_type => "boolean", is_nullable => 1 },
  "pilotage_available",
  { data_type => "boolean", is_nullable => 1 },
  "pilotage_local_assistance",
  { data_type => "boolean", is_nullable => 1 },
  "pilotage_advisable",
  { data_type => "boolean", is_nullable => 1 },
  "tugs_can_salvage",
  { data_type => "boolean", is_nullable => 1 },
  "tugs_can_assist",
  { data_type => "boolean", is_nullable => 1 },
  "quarantine_pratique_required",
  { data_type => "boolean", is_nullable => 1 },
  "quarantine_sscc_certification_required",
  { data_type => "boolean", is_nullable => 1 },
  "quarantine_other_required",
  { data_type => "boolean", is_nullable => 1 },
  "comm_phone",
  { data_type => "boolean", is_nullable => 1 },
  "comm_fax",
  { data_type => "boolean", is_nullable => 1 },
  "comm_radio",
  { data_type => "boolean", is_nullable => 1 },
  "comm_vhf",
  { data_type => "boolean", is_nullable => 1 },
  "comm_air",
  { data_type => "boolean", is_nullable => 1 },
  "comm_rail",
  { data_type => "boolean", is_nullable => 1 },
  "load_offload_wharf",
  { data_type => "boolean", is_nullable => 1 },
  "load_offload_anchor",
  { data_type => "boolean", is_nullable => 1 },
  "load_offload_medium_moor",
  { data_type => "boolean", is_nullable => 1 },
  "load_offload_beach_moor",
  { data_type => "boolean", is_nullable => 1 },
  "load_offload_ice_moor",
  { data_type => "boolean", is_nullable => 1 },
  "medical_facilities",
  { data_type => "boolean", is_nullable => 1 },
  "garbage_disposal",
  { data_type => "boolean", is_nullable => 1 },
  "degaussing_available",
  { data_type => "boolean", is_nullable => 1 },
  "dirty_ballast",
  { data_type => "boolean", is_nullable => 1 },
  "fixed_cranes",
  { data_type => "boolean", is_nullable => 1 },
  "mobile_cranes",
  { data_type => "boolean", is_nullable => 1 },
  "floating_cranes",
  { data_type => "boolean", is_nullable => 1 },
  "cranes_lift_100_tons",
  { data_type => "boolean", is_nullable => 1 },
  "cranes_lift_50_100_tons",
  { data_type => "boolean", is_nullable => 1 },
  "cranes_lift_25_49_tons",
  { data_type => "boolean", is_nullable => 1 },
  "cranes_lift_0_24_tons",
  { data_type => "boolean", is_nullable => 1 },
  "longshore_services",
  { data_type => "boolean", is_nullable => 1 },
  "electrical_services",
  { data_type => "boolean", is_nullable => 1 },
  "steam_services",
  { data_type => "boolean", is_nullable => 1 },
  "navigation_equipment_services",
  { data_type => "boolean", is_nullable => 1 },
  "electrical_repair_services",
  { data_type => "boolean", is_nullable => 1 },
  "supplies_provisions",
  { data_type => "boolean", is_nullable => 1 },
  "supplies_water",
  { data_type => "boolean", is_nullable => 1 },
  "supplies_fuel_oil",
  { data_type => "boolean", is_nullable => 1 },
  "supplies_diesel_oil",
  { data_type => "boolean", is_nullable => 1 },
  "supplies_deck",
  { data_type => "boolean", is_nullable => 1 },
  "supplies_engine",
  { data_type => "boolean", is_nullable => 1 },
  "repairs",
  { data_type => "text", is_nullable => 1 },
  "drydock",
  { data_type => "text", is_nullable => 1 },
  "railway",
  { data_type => "text", is_nullable => 1 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "geometry",
  { data_type => "geometry", is_nullable => 1, size => "12544,3519" },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("port_name_lat_lon", ["port_name", "latitude", "longitude"]);
__PACKAGE__->has_many(
  "company_ports",
  "EmpireLogistics::Schema::Result::CompanyPort",
  { "foreign.port" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many(
    'companies' => 'company_ports', 'company'
);
__PACKAGE__->many_to_many(
    'labor_organizations' => 'labor_organization_ports', 'labor_organization'
);
__PACKAGE__->many_to_many(
    'work_stoppages' => 'port_work_stoppages', 'work_stoppage'
);
__PACKAGE__->many_to_many(
    'addresses' => 'port_addresses', 'address'
);

__PACKAGE__->has_many(
  "labor_organization_ports",
  "EmpireLogistics::Schema::Result::LaborOrganizationPort",
  { "foreign.port" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "port_addresses",
  "EmpireLogistics::Schema::Result::PortAddress",
  { "foreign.port" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "port_tonnages",
  "EmpireLogistics::Schema::Result::PortTonnage",
  { "foreign.port" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "port_work_stoppages",
  "EmpireLogistics::Schema::Result::PortWorkStoppage",
  { "foreign.port" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
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

sub name {
    my $self = shift;
    return $self->port_name;
}

__PACKAGE__->meta->make_immutable;
1;
