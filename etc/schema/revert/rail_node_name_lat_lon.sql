-- Revert rail_node_name_lat_lon

BEGIN;

    alter table rail_node drop constraint if exists rail_node_name_lat_lon;

COMMIT;
