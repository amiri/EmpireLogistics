drop table if exists warehouse_type cascade;
create table warehouse_type (
    id serial primary key not null,
    name text
);
