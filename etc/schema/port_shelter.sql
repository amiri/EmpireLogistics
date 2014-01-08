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
