drop table if exists warehouse cascade;
create table warehouse (
    id serial primary key not null,
    name text,
    street_address text,
    city text,
    state text,
    postal_code text,
    country text,
    description text,
    status text,
    area integer,
    owner warehouse_owner,
    date_opened date,
    geometry geometry
);
