drop table if exists lines cascade;
create table lines (
    id integer not null,
    link_id text,
    route_id text text,
    miles double precision,
    direction text,
    track_type text,
    grade text,
    gauge text,
    status text,
    passenger boolean not null,
    military_subsystem text,
    signal_system text,
    traffic_density integer,
    a_junction integer,
    b_junction integer,
    subdivision integer,
    owner1 integer,
    owner2 integer,
    trackage_rights1 integer,
    trackage_rights2 integer,
    trackage_rights3 integer,
    geometry geometry
);

drop table if exists track_type cascade;
create table track_type (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into track_type (name,detail) values
    ("A", "Main"),
    ("S", "Siding"),
    ("P", "Spur"),
    ("F", "Car Ferry"),
    ("Y", "Yard Track"),
    ("B", "Main Through Yard"),
	("R", "Transfer Tracks"),
	("T", "Station Tracks"),
	("Z", "Notional Connector");

drop table if exists track_grade cascade;
create table track_grade_cascade (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into track_grade (name,detail) values
    ("G", "At Grade"),
    ("F", "Controlled Access"),
    ("S", "In Street"),
    ("E", "Uncontrolled"),
    ("T", "Tunnel(s)"),
    ("I", "Grade Separated"),
    ("B", "Bridge"),
    ("U", "Underground"),
    ("H", "Snowshed");

drop table if exists track_gauge cascade;
create table track_gauge_cascade (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into track_gauge (name,detail) values
    ("_", "Standard"),
    ("E", "Electrified, Standard"),
    ("C", "Cog"),
    ("N", "Narrow"),
    ("R", "Transit");

drop table if exists rail_status cascade;
create table rail_status_cascade (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_status (name,detail) values
    ("K", "Active"),
    ("A", "Abandoned"),
    ("M", "Embargoed (Rails Exist)"),
    ("P", "Suspended (Out Of Service, But Reopenable)");

    drop table if exists rail_density cascade;
create table rail_density (
    id serial primary key not null,
    name integer not null,
    detail text not null
);
insert into rail_density (name,detail) values
    (0,"Unknown"),
    (1,"≥ 5m tons/year"),
    (2,"≥ 10m tons/year"),
    (3,"≥ 20m tons/year"),
    (4,"≥ 40m tons/year"),
    (5,"≥ 60m tons/year"),
    (6,"≥ 100m tons/year"),
    (7,"> 100m tons/year");

