-- Revert company_rail_lines

BEGIN;

drop table if exists company_rail_line cascade;

COMMIT;
