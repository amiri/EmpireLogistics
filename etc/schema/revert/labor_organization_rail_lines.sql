-- Revert labor_organization_rail_lines

BEGIN;

drop table if exists labor_organization_rail_line cascade;

COMMIT;
