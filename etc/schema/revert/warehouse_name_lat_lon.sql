-- Revert warehouse_name_lat_lon

BEGIN;

    alter table warehouse drop constraint if exists warehouse_name_lat_lon;

COMMIT;
