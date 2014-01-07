drop table if exists rail_line_class cascade;
create table rail_line_class (
    id serial primary key not null,
    name text not null,
    detail text not null
);

insert into rail_line_class (name,detail) values
    ('A', 'A-Main'),
    ('B', 'B-Main'),
    ('C', 'C-Main'),
    ('G', 'A-Branch'),
    ('H', 'B-Branch'),
    ('X', 'Non-Freight');

