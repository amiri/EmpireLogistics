-- Verify media_rels

BEGIN;

    SELECT 1/COUNT(*) table_name from information_schema.columns where table_name = 'port_media';
    SELECT 1/COUNT(*) table_name from information_schema.columns where table_name = 'warehouse_media';
    SELECT 1/COUNT(*) table_name from information_schema.columns where table_name = 'rail_node_media';


ROLLBACK;
