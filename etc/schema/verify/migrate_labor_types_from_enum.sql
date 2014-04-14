-- Verify migrate_labor_types_from_enum

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'labor_organization' and column_name = 'organization_type' and data_type = 'integer';

ROLLBACK;
