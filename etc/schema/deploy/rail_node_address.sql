-- Deploy rail_node_address

BEGIN;


create table rail_node_address (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    rail_node integer not null,
    address integer not null,
    unique (rail_node,address)
);
create index on rail_node_address (rail_node);
create index on rail_node_address (address);
alter table rail_node_address add foreign key (rail_node) references rail_node(id) on delete cascade;
alter table rail_node_address add foreign key (address) references address(id) on delete cascade;
create trigger update_time before update on rail_node_address for each row execute procedure update_timestamp();
INSERT INTO object_type (name) VALUES ('rail_node_address');

COMMIT;
