-- Verify rail_node_address

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'rail_node_address';

ROLLBACK;
