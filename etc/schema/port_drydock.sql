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
