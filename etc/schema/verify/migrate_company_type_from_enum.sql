-- Verify migrate_company_type_from_enum

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'company' and column_name = 'company_type' and data_type = 'integer';

ROLLBACK;
