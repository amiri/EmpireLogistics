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
