drop table if exists port cascade;
create table port (
    id integer not null primary key,
    port_name text,
    country text,
    harbor_size text,
    harbor_type text,
    shelter text,
    entry_tide_restriction boolean,
    entry_swell_restriction boolean,
    entry_ice_restriction boolean,
    entry_other_restriction boolean,
    overhead_limits boolean,
    channel_depth text,
    anchor_depth text,
    cargo_pier_depth text,
    oil_terminal_depth text,
    tide_range integer,
    max_vessel_size text,
    good_holding_ground boolean,
    turning_basin  boolean,
    first_port_of_entry boolean,
    us_representative boolean,
    eta_message boolean,
    pilotage_required boolean,
    pilotage_available boolean,
    pilotage_local_assistance boolean,
    pilotage_advisable boolean,
    tugs_can_salvage boolean,
    tugs_can_assist boolean,
    quarantine_pratique_required boolean,
    quarantine_sscc_certification_required boolean,
    quarantine_other_required boolean,
    comm_phone boolean,
    comm_fax boolean,
    comm_radio boolean,
    comm_vhf boolean,
    comm_air boolean,
    comm_rail boolean,
    load_offload_wharf boolean,
    load_offload_anchor boolean,
    load_offload_medium_moor boolean,
    load_offload_beach_moor boolean,
    load_offload_ice_moor boolean,
    medical_facilities boolean,
    garbage_disposal boolean,
    degaussing_available boolean,
    dirty_ballast boolean,
    fixed_cranes boolean,
    mobile_cranes boolean,
    floating_cranes boolean,
    cranes_lift_100_tons boolean,
    cranes_lift_50_100_tons boolean,
    cranes_lift_25_49_tons boolean,
    cranes_lift_0_24_tons boolean,
    longshore_services boolean,
    electrical_services boolean,
    steam_services boolean,
    navigation_equipment_services boolean,
    electrical_repair_services boolean,
    supplies_provisions boolean,
    supplies_water boolean,
    supplies_fuel_oil boolean,
    supplies_diesel_oil boolean,
    supplies_deck boolean,
    supplies_engine boolean,
    repairs text,
    drydock text,
    railway text,
    geometry geometry
);
insert into port (
    id,
    port_name,
    country,
    harbor_size,
    harbor_type,
    shelter,
    entry_tide_restriction,
    entry_swell_restriction,
    entry_ice_restriction,
    entry_other_restriction,
    overhead_limits,
    channel_depth,
    anchor_depth,
    cargo_pier_depth,
    oil_terminal_depth,
    tide_range,
    max_vessel_size,
    good_holding_ground,
    turning_basin,
    first_port_of_entry,
    us_representative,
    eta_message,
    pilotage_required,
    pilotage_available,
    pilotage_local_assistance,
    pilotage_advisable,
    tugs_can_salvage,
    tugs_can_assist,
    quarantine_pratique_required,
    quarantine_sscc_certification_required,
    quarantine_other_required,
    comm_phone,
    comm_fax,
    comm_radio,
    comm_vhf,
    comm_air,
    comm_rail,
    load_offload_wharf,
    load_offload_anchor,
    load_offload_medium_moor,
    load_offload_beach_moor,
    load_offload_ice_moor,
    medical_facilities,
    garbage_disposal,
    degaussing_available,
    dirty_ballast,
    fixed_cranes,
    mobile_cranes,
    floating_cranes,
    cranes_lift_100_tons,
    cranes_lift_50_100_tons,
    cranes_lift_25_49_tons,
    cranes_lift_0_24_tons,
    longshore_services,
    electrical_services,
    steam_services,
    navigation_equipment_services,
    electrical_repair_services,
    supplies_provisions,
    supplies_water,
    supplies_fuel_oil,
    supplies_diesel_oil,
    supplies_deck,
    supplies_engine,
    repairs,
    drydock,
    railway,
    geometry
) select
    rp.gid as id,
    rp.port_name as port_name,
    rp.country as country,
    harbor_size.detail as harbor_size,
    harbor_type.detail as harbor_type,
    port_shelter.detail as shelter,
        CASE rp.entry_tide
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as entry_tide_restriction,
        CASE rp.entryswell
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as entry_swell_restriction,
        CASE rp.entry_ice
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as entry_ice_restriction,
        CASE rp.entryother
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as entry_other_restriction,
        CASE rp.overhd_lim
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as overhead_limits,
    channel_depth.detail as channel_depth,
    anchor_depth.detail as anchor_depth,
    cargo_depth.detail as cargo_pier_depth,
    oil_terminal_depth.detail as oil_terminal_depth,
    rp.tide_range::integer as tide_range,
    vessel_size.detail as max_vessel_size,
        CASE rp.holdground
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as good_holding_ground,
        CASE rp.turn_basin
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as turning_basin,
        CASE rp.portofentr
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as first_port_of_entry,
        CASE rp.us_rep
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as us_representative,
        CASE rp.etamessage
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as eta_message,
        CASE rp.pilot_reqd
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as pilotage_required,
        CASE rp.pilotavail
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as pilotage_available,
        CASE rp.loc_assist
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as pilotage_local_assistance,
        CASE rp.pilotadvsd
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as pilotage_advisable,
        CASE rp.tugsalvage
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as tugs_can_salvage,
        CASE rp.tug_assist
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as tugs_can_assist,
        CASE rp.pratique
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as quarantine_pratique_required,
        CASE rp.sscc_cert
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as quarantine_sscc_certification_required,
        CASE rp.quar_other
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as quarantine_other_required,
        CASE rp.comm_phone
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as comm_phone,
        CASE rp.comm_fax
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as comm_fax,
        CASE rp.comm_radio
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as comm_radio,
        CASE rp.comm_vhf
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as comm_vhf,
        CASE rp.comm_air
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as comm_air,
        CASE rp.comm_rail
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as comm_rail,
        CASE rp.cargowharf
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as load_offload_wharf,
        CASE rp.cargo_anch
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as load_offload_anchor,
        CASE rp.cargmdmoor
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as load_offload_medium_moor,
        CASE rp.carbchmoor
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as load_offload_beach_moor,
        CASE rp.caricemoor
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as load_offload_ice_moor,
        CASE rp.med_facil
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as medical_facilities,
        CASE rp.garbage
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as garbage_disposal,
        CASE rp.degauss
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as degaussing_available,
        CASE rp.drtyballst
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as dirty_ballast,
        CASE rp.cranefixed
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as fixed_cranes,
        CASE rp.cranemobil
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as mobile_cranes,
        CASE rp.cranefloat
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as floating_cranes,
        CASE rp.lift_100_
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as cranes_lift_100_tons,
        CASE rp.lift50_100
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as cranes_lift_50_100_tons,
        CASE rp.lift_25_49
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as cranes_lift_25_49_tons,
        CASE rp.lift_0_24
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as cranes_lift_0_24_tons,
        CASE rp.longshore
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as longshore_services,
        CASE rp.electrical
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as electrical_services,
        CASE rp.serv_steam
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as steam_services,
        CASE rp.nav_equip
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as navigation_equipment_services,
        CASE rp.elecrepair
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as electrical_repair_services,
        CASE rp.provisions
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as supplies_provisions,
        CASE rp.water
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as supplies_water,
        CASE rp.fuel_oil
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as supplies_fuel_oil,
        CASE rp.diesel
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as supplies_diesel_oil,
        CASE rp.decksupply
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as supplies_deck,
        CASE rp.eng_supply
            WHEN 'Y' THEN TRUE
            WHEN 'N' THEN FALSE
            ELSE null
        END as supplies_engine,
    repair.detail as repairs,
    drydock.detail as drydock,
    railway.detail as railway,
    rp.geom as geometry
from raw_port rp
    left join port_harbor_size harbor_size on rp.harborsize = harbor_size.name
    left join port_harbor_type harbor_type on rp.harbortype = harbor_type.name
    left join port_shelter port_shelter on rp.shelter = port_shelter.name
    left join port_depth_feet channel_depth on rp.chan_depth = channel_depth.name
    left join port_depth_feet anchor_depth on rp.anch_depth = anchor_depth.name
    left join port_depth_feet cargo_depth on rp.cargodepth = cargo_depth.name
    left join port_depth_feet oil_terminal_depth on rp.oil_depth = oil_terminal_depth.name
    left join port_vessel_size vessel_size on rp.max_vessel = vessel_size.name
    left join port_repair repair on rp.repaircode = repair.name
    left join port_drydock drydock on rp.drydock = drydock.name
    left join port_drydock railway on rp.railway = railway.name
;
