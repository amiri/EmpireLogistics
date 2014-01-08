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



