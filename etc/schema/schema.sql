drop table if exists rail_line cascade;
create table rail_line (
    id integer not null primary key,
    link_id text,
    route_id text,
    miles double precision,
    direction text,
    track_type text,
    grade text,
    gauge text,
    status text,
    passenger text,
    military_subsystem text,
    signal_system text,
    traffic_density text,
    line_class text,
    a_junction text,
    b_junction text,
    subdivision text,
    owner1 text,
    owner2 text,
    trackage_rights1 text,
    trackage_rights2 text,
    trackage_rights3 text,
    geometry geometry
);
drop table if exists rail_interline cascade;
create table rail_interline (
    id integer not null primary key,
    interline_id_number integer,
    forwarding_node text,
    receiving_node text,
    forwarding_node_owner text, 
    receiving_node_owner text,
    junction_code text,
    impedance integer,
    description text,
    geometry geometry
);
drop table if exists rail_node cascade;
create table rail_node (
    id integer not null primary key,
    junction_id integer,
    name text,
    incident_links integer,
    geometry geometry
);
drop sequence if exists rail_ownership_id_seq cascade;
drop table if exists rail_ownership cascade;
create table rail_ownership (
    id serial primary key not null,
    aar_code integer,
    name text,
    family text,
    history text,
    flag text,
    reporting_mark text
);
CREATE INDEX reporting_mark_idx ON rail_ownership (reporting_mark);
CREATE INDEX name_idx ON rail_ownership (name);

drop table if exists rail_subdivision cascade;
create table rail_subdivision (
    id serial primary key not null,
    name text,
    full_name text,
    wmark text,
    subdivision_type text,
    comments text
);
create index subdiv_name_idx on rail_subdivision (name);
create index subdiv_wmark_idx on rail_subdivision (wmark);

drop sequence if exists state_id_seq cascade;
drop table if exists state cascade;
create table state (
    id serial primary key not null,
    abbreviation text,
    name text
);
CREATE INDEX state_abbreviation_idx ON state (abbreviation);
CREATE INDEX state_name_idx ON state (name);

drop table if exists rail_subdivision_state cascade;
create table rail_subdivision_state (
    subdivision integer not null,
    state integer not null,
    primary key (subdivision, state)
);
alter table rail_subdivision_state add foreign key ("state") references state("id");
alter table rail_subdivision_state add foreign key ("subdivision") references rail_subdivision("id");

drop table if exists rail_track_type cascade;
create table rail_track_type (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_track_type (name,detail) values
    ('A', 'Main'),
    ('S', 'Siding'),
    ('P', 'Spur'),
    ('F', 'Car Ferry'),
    ('Y', 'Yard Track'),
    ('B', 'Main Through Yard'),
	('R', 'Transfer Tracks'),
	('T', 'Station Tracks'),
	('Z', 'Notional Connector');

drop table if exists rail_track_grade cascade;
create table rail_track_grade (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_track_grade (name,detail) values
    ('G', 'At Grade'),
    ('F', 'Controlled Access'),
    ('S', 'In Street'),
    ('E', 'Uncontrolled'),
    ('T', 'Tunnel(s)'),
    ('I', 'Grade Separated'),
    ('B', 'Bridge'),
    ('U', 'Underground'),
    ('H', 'Snowshed');

drop table if exists rail_track_gauge cascade;
create table rail_track_gauge (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_track_gauge (name,detail) values
    ('S', 'Standard'),
    ('E', 'Electrified, Standard'),
    ('C', 'Cog'),
    ('N', 'Narrow'),
    ('R', 'Transit');

drop table if exists rail_status cascade;
create table rail_status (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_status (name,detail) values
    ('K', 'Active'),
    ('A', 'Abandoned'),
    ('M', 'Embargoed (Rails Exist)'),
    ('P', 'Suspended (Out Of Service, But Reopenable)');

drop table if exists rail_density cascade;
create table rail_density (
    id serial primary key not null,
    name integer not null,
    detail text not null
);
insert into rail_density (name,detail) values
    (0,'Unknown'),
    (1,'≥ 5m tons/year'),
    (2,'≥ 10m tons/year'),
    (3,'≥ 20m tons/year'),
    (4,'≥ 40m tons/year'),
    (5,'≥ 60m tons/year'),
    (6,'≥ 100m tons/year'),
    (7,'> 100m tons/year');

drop table if exists rail_signal cascade;
create table rail_signal (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_signal (name,detail) values
    ('S', 'Automatic Control System'),
    ('T', 'Automatic Train Control'),
    ('U', 'Automatic Train Stop'),
    ('I', 'Itc (Amtk Incremental Train Control)'),
    ('C', 'Centralized Traffic Control'),
    ('B', 'Automatic Block Signals'),
    ('M', 'Manual'),
    ('O', 'Timetable And Train Order');

drop table if exists rail_passenger cascade;
create table rail_passenger (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_passenger (name,detail) values
    ('A', 'Amtrak'),
    ('C', 'Commuter'),
    ('B', 'Amtrak And Commuter'),
    ('V', 'Via (Amtrak Takes Precedence)'),
    ('R', 'Transit'),
    ('S', 'Scenic'),
    ('T', 'Tourist'),
    ('O', 'Other'),
    ('X', 'Former Amtrak Route');

drop table if exists rail_military cascade;
create table rail_military (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_military (name,detail) values
    ('S', 'STRACNET System'),
    ('C', 'STRACNET Connector');

drop table if exists rail_line_class cascade;
create table rail_line_class (
    id serial primary key not null,
    name text not null,
    detail text not null
);

insert into rail_line_class (name,detail) values
    ('A', 'A-Main'),
    ('B', 'B-Main'),
    ('C', 'C-Main'),
    ('G', 'A-Branch'),
    ('H', 'B-Branch'),
    ('X', 'Non-Freight');

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
drop table if exists port_depth_feet cascade;
create table port_depth_feet (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_depth_feet (name,detail) values
    ('A', '76+ feet'),
    ('B', '71-75 feet'),
    ('C', '66-70 feet'),
    ('D', '61-65 feet'),
    ('E', '56-60 feet'),
    ('F', '51-55 feet'),
    ('G', '46-50 feet'),
    ('H', '41-45 feet'),
    ('J', '36-40 feet'),
    ('K', '31-35 feet'),
    ('L', '26-30 feet'),
    ('M', '21-25 feet'),
    ('N', '16-20 feet'),
    ('O', '11-15 feet'),
    ('P', '6-10 feet'),
    ('Q', '0-5 feet');

drop table if exists port_depth_feet cascade;
create table port_depth_feet (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_depth_feet (name,detail) values
    ('A', '76+ feet'),
    ('B', '71–75 feet'),
    ('C', '66–70 feet'),
    ('D', '61–65 feet'),
    ('E', '56–60 feet'),
    ('F', '51–55 feet'),
    ('G', '46–50 feet'),
    ('H', '41–45 feet'),
    ('J', '36–40 feet'),
    ('K', '31–35 feet'),
    ('L', '26–30 feet'),
    ('M', '21–25 feet'),
    ('N', '16–20 feet'),
    ('O', '11–15 feet'),
    ('P', '6–10 feet'),
    ('Q', '0–5 feet');
drop table if exists port_depth_meters cascade;
create table port_depth_meters (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_depth_meters (name,detail) values
    ('A', '23.2+ meters'),
    ('B', '21.6–22.9 meters'),
    ('C', '20.1–21.3 meters'),
    ('D', '18.6–19.8 meters'),
    ('E', '17.1–18.2 meters'),
    ('F', '15.5–16.8 meters'),
    ('G', '14.0–15.2 meters'),
    ('H', '12.5–13.7 meters'),
    ('J', '11.0–12.2 meters'),
    ('K', '9.4–10.7 meters'),
    ('L', '7.9–9.1 meters'),
    ('M', '6.4–7.6 meters'),
    ('N', '4.9–6.1 meters'),
    ('O', '3.4–4.6 meters'),
    ('P', '1.8–3.0 meters'),
    ('Q', '0–1.5 meters');

drop table if exists port_drydock cascade;
create table port_drydock (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_drydock (name,detail) values
    ('L', 'Large'),
    ('M', 'Medium'),
    ('S', 'Small');

drop table if exists port_harbor_size cascade;
create table port_harbor_size (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_harbor_size (name,detail) values
    ('L', 'Large'),
    ('M', 'Medium'),
    ('S', 'Small'),
    ('V', 'Very Small');

drop table if exists port_harbor_type cascade;
create table port_harbor_type (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_harbor_type (name,detail) values
    ('CB', 'Coastal Breakwater'),
    ('CN', 'Coastal Natural'),
    ('CT', 'Coastal Tide Gate'),
    ('LC', 'Lake/Canal'),
    ('OR', 'Open Roadstead'),
    ('RB', 'River Basin'),
    ('RN', 'River Natural'),
    ('RT', 'River Tide Gate'),
    ('TH', 'Typhoon Harbor');

drop table if exists port_repair cascade;
create table port_repair (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_repair (name,detail) values
    ('A', 'Major'),
    ('B', 'Moderate'),
    ('C', 'Limited'),
    ('D', 'Emergency Only'),
    ('N', 'None');

drop table if exists port_shelter cascade;
create table port_shelter (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_shelter (name,detail) values
    ('E', 'EXCELLENT'),
    ('F', 'FAIR'),
    ('G', 'GOOD'),
    ('N', 'NONE'),
    ('P', 'POOR');

drop table if exists port_tonnage cascade;
create table port_tonnage (
    id serial primary key not null,
    port integer not null references port(id),
    year integer not null,
    domestic_tonnage integer,
    foreign_tonnage integer,
    import_tonnage integer,
    export_tonnage integer,
    total_tonnage integer,
    unique (port,year)
);

drop table if exists port_vessel_size cascade;
create table port_vessel_size (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_vessel_size (name,detail) values
    ('L', '500+ feet'),
    ('M', '≥ 500 feet');

drop type if exists warehouse_owner cascade;
create type warehouse_owner as enum ('walmart', 'target', 'costco', 'krogers', 'walgreens', 'home depot', 'amazon');

drop type if exists warehouse_status cascade;
create type warehouse_status as enum ('open', 'closed');

drop table if exists warehouse cascade;
create table warehouse (
    id serial primary key not null,
    name text,
    street_address text,
    city text,
    state text,
    postal_code text,
    country text,
    description text,
    status warehouse_status,
    area integer,
    owner warehouse_owner,
    date_opened date,
    geometry geometry
);

drop table if exists walmart;
create table walmart (
    id serial primary key not null,
    walmart_id text
);

drop table if exists warehouse_walmart;
create table warehouse_walmart (
    warehouse integer not null,
    walmart integer not null,
    primary key (warehouse, walmart)
);
