drop table if exists rail_military cascade;
create table rail_military (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_military (name,detail) values
    ('S', 'STRACNET System'),
    ('C', 'STRACNET Connector');
