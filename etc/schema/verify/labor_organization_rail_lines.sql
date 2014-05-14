-- Verify labor_organization_rail_lines

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'labor_organization_rail_line';

ROLLBACK;
