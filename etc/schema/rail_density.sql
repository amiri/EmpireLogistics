drop table if exists rail_density cascade;
create table rail_density (
    id serial primary key not null,
    name integer not null,
    detail text not null
);
insert into rail_density (name,detail) values
    (0,'Unknown'),
    (1,'≥ 5m tons/year'),
    (2,'≥ 10m tons/year'),
    (3,'≥ 20m tons/year'),
    (4,'≥ 40m tons/year'),
    (5,'≥ 60m tons/year'),
    (6,'≥ 100m tons/year'),
    (7,'> 100m tons/year');
