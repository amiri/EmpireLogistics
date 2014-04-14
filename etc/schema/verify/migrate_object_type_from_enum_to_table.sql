-- Verify migrate_object_type_from_enum_to_table

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'edit_history' and column_name = 'object_type' and data_type = 'integer';

ROLLBACK;
