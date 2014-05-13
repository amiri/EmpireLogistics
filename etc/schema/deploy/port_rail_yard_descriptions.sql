-- Deploy port_rail_yard_descriptions

BEGIN;

alter table port add column description text default null;
alter table rail_node add column description text default null;
alter table rail_line add column description text default null;

COMMIT;
