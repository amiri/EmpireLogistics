-- Revert port_name_lat_lon

BEGIN;

    alter table port drop constraint if exists port_name_lat_lon;

COMMIT;
