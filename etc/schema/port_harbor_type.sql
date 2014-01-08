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
