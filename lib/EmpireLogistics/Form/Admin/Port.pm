package EmpireLogistics::Form::Admin::Port;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'Printable' );
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'port-form' );
has '+item_class' => ( default => 'Port' );

has_field 'id' => (
    type  => 'Hidden',
    label => 'User ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_delete_time,
);

has_field 'port_name' => ( type => 'Text', required => 1, );
has_field 'longitude' => ( type => 'Text', required => 1, );
has_field 'latitude' => ( type => 'Text', required => 1, );
has_field 'geometry' => ( type => 'Text', disabled => 1, readonly => 1, );
has_field 'country' => ( type => 'Text', required => 1, );
has_field 'harbor_size' => ( type => 'Text', required => 1, );
has_field 'harbor_type' => ( type => 'Text', required => 1, );
has_field 'shelter' => ( type => 'Text', );
has_field 'entry_tide_restriction' => ( type => 'Boolean', );
has_field 'entry_swell_restriction' => ( type => 'Boolean', );
has_field 'entry_ice_restriction' => ( type => 'Boolean', );
has_field 'entry_other_restriction' => ( type => 'Boolean', );
has_field 'overhead_limits' => ( type => 'Boolean', );
has_field 'channel_depth' => ( type => 'Text', );
has_field 'anchor_depth' => ( type => 'Text', );
has_field 'cargo_pier_depth' => ( type => 'Text', required => 1, );
has_field 'oil_terminal_depth' => ( type => 'Text', );
has_field 'tide_range' => ( type => 'Integer', );
has_field 'max_vessel_size' => ( type => 'Text', required => 1, );
has_field 'good_holding_ground' => ( type => 'Boolean', );
has_field 'turning_basin' => ( type => 'Boolean', );
has_field 'first_port_of_entry' => ( type => 'Boolean', );
has_field 'us_representative' => ( type => 'Boolean', );
has_field 'eta_message' => ( type => 'Boolean', );
has_field 'pilotage_required' => ( type => 'Boolean', );
has_field 'pilotage_available' => ( type => 'Boolean', );
has_field 'pilotage_local_assistance' => ( type => 'Boolean', );
has_field 'pilotage_advisable' => ( type => 'Boolean', );
has_field 'tugs_can_salvage' => ( type => 'Boolean', );
has_field 'tugs_can_assist' => ( type => 'Boolean', );
has_field 'quarantine_pratique_required' => ( type => 'Boolean', );
has_field 'quarantine_sscc_certification_required' => ( type => 'Boolean', );
has_field 'quarantine_other_required' => ( type => 'Boolean', );
has_field 'comm_phone' => ( type => 'Boolean', );
has_field 'comm_fax' => ( type => 'Boolean', );
has_field 'comm_radio' => ( type => 'Boolean', );
has_field 'comm_vhf' => ( type => 'Boolean', );
has_field 'comm_air' => ( type => 'Boolean', );
has_field 'comm_rail' => ( type => 'Boolean', );
has_field 'load_offload_wharf' => ( type => 'Boolean', );
has_field 'load_offload_anchor' => ( type => 'Boolean', );
has_field 'load_offload_medium_moor' => ( type => 'Boolean', );
has_field 'load_offload_beach_moor' => ( type => 'Boolean', );
has_field 'load_offload_ice_moor' => ( type => 'Boolean', );
has_field 'medical_facilities' => ( type => 'Boolean', );
has_field 'garbage_disposal' => ( type => 'Boolean', );
has_field 'degaussing_available' => ( type => 'Boolean', );
has_field 'dirty_ballast' => ( type => 'Boolean', );
has_field 'fixed_cranes' => ( type => 'Boolean', );
has_field 'mobile_cranes' => ( type => 'Boolean', );
has_field 'floating_cranes' => ( type => 'Boolean', );
has_field 'cranes_lift_100_tons' => ( type => 'Boolean', );
has_field 'cranes_lift_50_100_tons' => ( type => 'Boolean', );
has_field 'cranes_lift_25_49_tons' => ( type => 'Boolean', );
has_field 'cranes_lift_0_24_tons' => ( type => 'Boolean', );
has_field 'longshore_services' => ( type => 'Boolean', );
has_field 'electrical_services' => ( type => 'Boolean', );
has_field 'steam_services' => ( type => 'Boolean', );
has_field 'navigation_equipment_services' => ( type => 'Boolean', );
has_field 'electrical_repair_services' => ( type => 'Boolean', );
has_field 'supplies_provisions' => ( type => 'Boolean', );
has_field 'supplies_water' => ( type => 'Boolean', );
has_field 'supplies_fuel_oil' => ( type => 'Boolean', );
has_field 'supplies_diesel_oil' => ( type => 'Boolean', );
has_field 'supplies_deck' => ( type => 'Boolean', );
has_field 'supplies_engine' => ( type => 'Boolean', );
has_field 'repairs' => ( type => 'Text', );
has_field 'drydock' => ( type => 'Text', );
has_field 'railway' => ( type => 'Text', );
has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
);


1;
