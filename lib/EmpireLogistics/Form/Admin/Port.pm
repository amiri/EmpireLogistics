package EmpireLogistics::Form::Admin::Port;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'PrintableAndNewline',
    'NotAllDigits');
use JSON::Any;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'port-form');
has '+item_class' => (default => 'Port');
has 'address_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'port_addresses',
);
has 'tonnage_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'port_tonnages',
);
has 'js_files' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [
            '/js/admin/port.js',
        ];
    },
);

sub build_render_list {
    return [
        'metadata_block', 'basic_block', 'location_block',
        'relations_block',
        'restrictions_block', 'pilotage_block',      'tugs_block',
        'quarantine_block',   'communication_block', 'facilities_block',
        'cranes_block',       'services_block',      'supplies_block',
        'tonnage_block',
        'submit',
    ];
}

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => ['companies', 'labor_organizations', 'work_stoppages'],
);

has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => ['id', 'create_time', 'update_time', 'delete_time',],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => ['overview_block', 'characteristics_block', 'description'],
);

has_block 'location_block' => (
    tag         => 'fieldset',
    label       => 'Location',
    render_list => ['latitude', 'longitude', 'geometry', 'address_block',],
);

has_block 'tonnage_block' => (
    tag         => 'fieldset',
    label       => 'Yearly Tonnage Statistics',
    render_list => ['port_tonnages', 'add_port_tonnage'],
);
has_field 'port_tonnages' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 0,
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Simple',
        tags           => {wrapper_tag => 'fieldset', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Simple',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'port_tonnages.contains' => (type => '+PortTonnage',);

has_field 'add_port_tonnage' => (
    type          => 'AddElement',
    repeatable    => 'port_tonnages',
    value         => 'Add another port tonnage record',
    element_class => ['btn btn-info']
);

has_field 'description' => (
    type => 'TextArea', element_wrapper_class => ['col-lg-10'],
);

# Companies
has_field 'companies' => (
    type => '+Company',
);

# Labor Organizations
has_field 'labor_organizations' => (
    type => '+LaborOrganization',
);

# Work Stoppages
has_field 'work_stoppages' => (
    type => '+WorkStoppage',
);

# Addresses
has_block 'address_block' => (
    tag           => 'fieldset',
    render_list   => ['addresses', 'add_address'],
    label         => 'Addresses',
    wrapper_class => 'addresses',
);
has_field 'addresses' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 0,
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Simple',
        tags           => {wrapper_tag => 'fieldset', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Simple',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'addresses.contains' => (type => '+Address',);

has_field 'add_address' => (
    type          => 'AddElement',
    repeatable    => 'addresses',
    value         => 'Add another address',
    element_class => ['btn btn-info']
);

sub options_addresses {
    my $self = shift;
    my $options =
        [map { {label => $_->addresses->street_address, value => $_->id,} }
            $self->item->addresses->active->all];
    return $options;
}

has_block 'overview_block' => (
    tag => 'fieldset',

    #class       => ['col-md-6'],
    label       => 'Overview',
    render_list => [
        'port_name',        'harbor_size',
        'harbor_type',      'channel_depth',
        'cargo_pier_depth', 'anchor_depth',
        'oil_terminal_depth',
    ],
);

has_block 'characteristics_block' => (
    tag => 'fieldset',

    #class       => ['col-md-6'],
    label       => 'Basic Characteristics',
    render_list => [
        'tide_range',          'max_vessel_size',
        'shelter',             'repairs',
        'drydock',             'railway',
        'good_holding_ground', 'turning_basin',
        'first_port_of_entry', 'us_representative',
        'eta_message',
    ],
);

has_block 'restrictions_block' => (
    tag         => 'fieldset',
    label       => 'Restrictions',
    render_list => [
        'entry_tide_restriction', 'entry_swell_restriction',
        'entry_ice_restriction',  'entry_other_restriction',
        'overhead_limits',
    ],
);

has_block 'pilotage_block' => (
    tag         => 'fieldset',
    label       => 'Pilotage',
    render_list => [
        'pilotage_required',         'pilotage_available',
        'pilotage_local_assistance', 'pilotage_advisable',
    ],
);

has_block 'tugs_block' => (
    tag         => 'fieldset',
    label       => 'Tugs',
    render_list => ['tugs_can_salvage', 'tugs_can_assist',],
);

has_block 'quarantine_block' => (
    tag         => 'fieldset',
    label       => 'Quarantine',
    render_list => [
        'quarantine_pratique_required',
        'quarantine_sscc_certification_required',
        'quarantine_other_required',
    ],
);

has_block 'communication_block' => (
    tag         => 'fieldset',
    label       => 'Communications',
    render_list => [
        'comm_phone', 'comm_fax', 'comm_radio', 'comm_vhf',
        'comm_air',   'comm_rail',
    ],
);

has_block 'offloading_block' => (
    tag         => 'fieldset',
    label       => 'Offloading',
    render_list => [
        'load_offload_wharf',       'load_offload_anchor',
        'load_offload_medium_moor', 'load_offload_beach_moor',
        'load_offload_ice_moor',
    ],
);

has_block 'facilities_block' => (
    tag         => 'fieldset',
    label       => 'Facilities',
    render_list => [
        'medical_facilities',   'garbage_disposal',
        'degaussing_available', 'dirty_ballast',
    ],
);

has_block 'cranes_block' => (
    tag         => 'fieldset',
    label       => 'Cranes',
    render_list => [
        'fixed_cranes',            'mobile_cranes',
        'floating_cranes',         'cranes_lift_100_tons',
        'cranes_lift_50_100_tons', 'cranes_lift_25_49_tons',
        'cranes_lift_0_24_tons',
    ],
);

has_block 'services_block' => (
    tag         => 'fieldset',
    label       => 'Services',
    render_list => [
        'longshore_services', 'electrical_services',
        'steam_services',     'navigation_equipment_services',
        'electrical_repair_services',
    ],
);
has_block 'supplies_block' => (
    tag         => 'fieldset',
    label       => 'Supplies',
    render_list => [
        'supplies_provisions', 'supplies_water',
        'supplies_fuel_oil',   'supplies_diesel_oil',
        'supplies_deck',       'supplies_engine',
    ],
);
has_block 'misc_block' => (
    tag         => 'fieldset',
    label       => 'Miscellaneous',
    render_list => ['repairs', 'drydock', 'railway',],
);
has_field 'id' => (
    type  => 'Hidden',
    label => 'Port ID',
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

# Basic
has_field 'port_name'   => (type => 'Text', required => 1,);
has_field 'harbor_size' => (type => 'Text', required => 1,);
has_field 'harbor_type' => (type => 'Text', required => 1,);
has_field 'channel_depth'      => (type => 'Text',);
has_field 'cargo_pier_depth'   => (type => 'Text',);
has_field 'anchor_depth'       => (type => 'Text',);
has_field 'oil_terminal_depth' => (type => 'Text',);

# Characteristics
has_field 'tide_range'      => (type => 'Integer',);
has_field 'max_vessel_size' => (type => 'Text', required => 1,);
has_field 'shelter'         => (type => 'Text',);
has_field 'good_holding_ground' => (type => 'Boolean',
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-2',],);
has_field 'turning_basin' => (type => 'Boolean',
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-2',],);
has_field 'first_port_of_entry' => (type => 'Boolean',
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-2',],);
has_field 'us_representative' => (type => 'Boolean',
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-2',],);
has_field 'eta_message' => (type => 'Boolean',
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-2',],);

# Location
has_field 'longitude' => (type => 'Text', required => 1,);
has_field 'latitude'  => (type => 'Text', required => 1,);
has_field 'geometry'  => (type => 'Text', disabled => 1, readonly => 1,);
has_field 'country' => (type => 'Text',);

# Restrictions
has_field 'entry_tide_restriction' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'entry_swell_restriction' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'entry_ice_restriction' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'entry_other_restriction' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'overhead_limits' => (type => 'InlineBoolean', do_wrapper => 0,);

# Pilotage
has_field 'pilotage_required'  => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'pilotage_available' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'pilotage_local_assistance' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'pilotage_advisable' => (type => 'InlineBoolean', do_wrapper => 0,);

# Tugs
has_field 'tugs_can_salvage' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'tugs_can_assist'  => (type => 'InlineBoolean', do_wrapper => 0,);

# Quarantine
has_field 'quarantine_pratique_required' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'quarantine_sscc_certification_required' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'quarantine_other_required' =>
    (type => 'InlineBoolean', do_wrapper => 0,);

# Communications
has_field 'comm_phone' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'comm_fax'   => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'comm_radio' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'comm_vhf'   => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'comm_air'   => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'comm_rail'  => (type => 'InlineBoolean', do_wrapper => 0,);

# Offloading
has_field 'load_offload_wharf'  => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'load_offload_anchor' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'load_offload_medium_moor' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'load_offload_beach_moor' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'load_offload_ice_moor' =>
    (type => 'InlineBoolean', do_wrapper => 0,);

# Facilities
has_field 'medical_facilities'   => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'garbage_disposal'     => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'degaussing_available' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'dirty_ballast'        => (type => 'InlineBoolean', do_wrapper => 0,);

# Cranes
has_field 'fixed_cranes'         => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'mobile_cranes'        => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'floating_cranes'      => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'cranes_lift_100_tons' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'cranes_lift_50_100_tons' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'cranes_lift_25_49_tons' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'cranes_lift_0_24_tons' =>
    (type => 'InlineBoolean', do_wrapper => 0,);

# Services
has_field 'longshore_services'  => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'electrical_services' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'steam_services'      => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'navigation_equipment_services' =>
    (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'electrical_repair_services' =>
    (type => 'InlineBoolean', do_wrapper => 0,);

# Supplies
has_field 'supplies_provisions' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'supplies_water'      => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'supplies_fuel_oil'   => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'supplies_diesel_oil' => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'supplies_deck'       => (type => 'InlineBoolean', do_wrapper => 0,);
has_field 'supplies_engine'     => (type => 'InlineBoolean', do_wrapper => 0,);

# Miscellaneous
has_field 'repairs' => (type => 'Text',);
has_field 'drydock' => (type => 'Text',);
has_field 'railway' => (type => 'Text',);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
);

1;
