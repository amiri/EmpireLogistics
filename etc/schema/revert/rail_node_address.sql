-- Revert rail_node_address

BEGIN;

drop table if exists rail_node_address cascade;

COMMIT;
