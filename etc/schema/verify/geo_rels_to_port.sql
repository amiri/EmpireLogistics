-- Verify geo_rels_to_port

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'port' and column_name = 'country' and data_type = 'integer';

ROLLBACK;
