-- Revert media_rels

BEGIN;

    drop table if exists port_media cascade;
    drop table if exists rail_node_media cascade;
    drop table if exists warehouse_media cascade;

COMMIT;
