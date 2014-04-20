package EmpireLogistics::Schema::ResultSet::Port;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'EmpireLogistics::Schema::ResultSet';

sub BUILDARGS { $_[2] }

has 'labels' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_labels',
);

sub _build_labels {
    my $self = shift;
    return {
        id                           => 'ID',
        create_time                  => 'Create Time',
        update_time                  => 'Update Time',
        delete_time                  => 'Deleted',
        port_name                    => "Port Name",
        country                      => "Country",
        harbor_size                  => "Harbor Size",
        harbor_type                  => "Harbor Type",
        shelter                      => "Shelter",
        entry_tide_restriction       => "Entry Tide Restriction?",
        entry_swell_restriction      => "Entry Swell Restriction?",
        entry_ice_restriction        => "Entry Ice Restriction?",
        entry_other_restriction      => "Entry Other Restrictions?",
        overhead_limits              => "Overhead Limits?",
        channel_depth                => "Channel Depth",
        anchor_depth                 => "Anchor Depth",
        cargo_pier_depth             => "Cargo Pier Depth",
        oil_terminal_depth           => "Oil Terminal Depth",
        tide_range                   => "Tide Range",
        max_vessel_size              => "Max Vessel Size",
        good_holding_ground          => "Good Holding Ground?",
        turning_basin                => "Turning Basin?",
        first_port_of_entry          => "First Port of Entry?",
        us_representative            => "US Representative?",
        eta_message                  => "ETA Message Available?",
        pilotage_required            => "Pilotage Required?",
        pilotage_available           => "Pilotage Available?",
        pilotage_local_assistance    => "Pilotage Local Assistance?",
        pilotage_advisable           => "Pilotage Advisable?",
        tugs_can_salvage             => "Tugs Can Salvage?",
        tugs_can_assist              => "Tugs Can Assist?",
        quarantine_pratique_required => "Vessel Quarantine Required?",
        quarantine_sscc_certification_required =>
            "SSCC Certification Required?",
        quarantine_other_required     => "Other Quarantine Required?",
        comm_phone                    => "Phone Comm.?",
        comm_fax                      => "Fax Comm.?",
        comm_radio                    => "Radio Comm.?",
        comm_vhf                      => "VHF Comm.?",
        comm_air                      => "Air Comm.?",
        comm_rail                     => "Rail Comm.?",
        load_offload_wharf            => "Wharf Offloading?",
        load_offload_anchor           => "Anchor Offloading?",
        load_offload_medium_moor      => "Medium Moor Offloading?",
        load_offload_beach_moor       => "Beach Moor Offloading?",
        load_offload_ice_moor         => "Ice Moor Offloading?",
        medical_facilities            => "Med. Facilities?",
        garbage_disposal              => "Garbage Disposal?",
        degaussing_available          => "Degaussing Available?",
        dirty_ballast                 => "Dirty Ballast?",
        fixed_cranes                  => "Fixed Cranes?",
        mobile_cranes                 => "Mobile Cranes?",
        floating_cranes               => "Floating Cranes?",
        cranes_lift_100_tons          => "Cranes 100+ Tons?",
        cranes_lift_50_100_tons       => "Cranes 50+ Tons?",
        cranes_lift_25_49_tons        => "Cranes 25+ Tons?",
        cranes_lift_0_24_tons         => "Cranes < 25 Tons?",
        longshore_services            => "Longshore Services?",
        electrical_services           => "Electrical Services?",
        steam_services                => "Steam Services?",
        navigation_equipment_services => "Nav. Equipmt. Services?",
        electrical_repair_services    => "Electrical Repair Services?",
        supplies_provisions           => "Provision Supplies?",
        supplies_water                => "Water Supplies?",
        supplies_fuel_oil             => "Fuel Oil Supplies?",
        supplies_diesel_oil           => "Diesel Oil Supplies?",
        supplies_deck                 => "Deck Supplies?",
        supplies_engine               => "Engine Supplies?",
        repairs                       => "Repairs?",
        drydock                       => "Drydock?",
        railway                       => "Railway?",
        latitude                      => "Latitude",
        longitude                     => "Longitude",
        geometry                      => "Geometry",
    };
}

__PACKAGE__->meta->make_immutable;

1;

