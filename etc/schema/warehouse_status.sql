drop type if exists warehouse_status cascade;
create type warehouse_status as enum ('open', 'closed');

