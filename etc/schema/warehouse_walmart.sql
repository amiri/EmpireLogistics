drop table if exists warehouse_walmart;
create table warehouse_walmart (
    warehouse integer not null,
    walmart integer not null,
    primary key (warehouse, walmart)
);
