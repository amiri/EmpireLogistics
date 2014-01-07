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

