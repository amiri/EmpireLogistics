drop table if exists port_vessel_size cascade;
create table port_vessel_size (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_vessel_size (name,detail) values
    ('L', '500+ feet'),
    ('M', '≥ 500 feet');
