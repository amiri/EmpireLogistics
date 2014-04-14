-- Verify migrate_warehouse_owner_from_enum_to_table

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'warehouse' and column_name = 'owner' and data_type = 'integer';

ROLLBACK;
