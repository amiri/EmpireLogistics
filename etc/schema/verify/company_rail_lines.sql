-- Verify company_rail_lines

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'company_rail_line';

ROLLBACK;
