drop table if exists rail_passenger cascade;
create table rail_passenger (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_passenger (name,detail) values
    ('A', 'Amtrak'),
    ('C', 'Commuter'),
    ('B', 'Amtrak And Commuter'),
    ('V', 'Via (Amtrak Takes Precedence)'),
    ('R', 'Transit'),
    ('S', 'Scenic'),
    ('T', 'Tourist'),
    ('O', 'Other'),
    ('X', 'Former Amtrak Route');
