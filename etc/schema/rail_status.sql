drop table if exists rail_status cascade;
create table rail_status (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_status (name,detail) values
    ('K', 'Active'),
    ('A', 'Abandoned'),
    ('M', 'Embargoed (Rails Exist)'),
    ('P', 'Suspended (Out Of Service, But Reopenable)');

