drop table if exists rail_track_gauge cascade;
create table rail_track_gauge (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_track_gauge (name,detail) values
    ('_', 'Standard'),
    ('E', 'Electrified, Standard'),
    ('C', 'Cog'),
    ('N', 'Narrow'),
    ('R', 'Transit');

