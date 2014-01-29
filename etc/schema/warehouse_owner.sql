drop type if exists warehouse_owner cascade;
create type warehouse_owner as enum ('walmart', 'target', 'costco', 'krogers');
