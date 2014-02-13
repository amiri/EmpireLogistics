drop table if exists port_tonnage cascade;
create table port_tonnage (
    id serial primary key not null,
    port integer not null references port(id),
    year integer not null,
    domestic_tonnage integer,
    foreign_tonnage integer,
    import_tonnage integer,
    export_tonnage integer,
    total_tonnage integer,
    unique (port,year)
);
