-- Verify unique_names_on_labor_org_and_company_types

BEGIN;

SELECT 1/COUNT(contype) FROM pg_constraint WHERE conrelid = (SELECT oid FROM pg_class WHERE relname = 'company_type') AND conname = 'company_type_unique_name' AND contype = 'u';
SELECT 1/COUNT(contype) FROM pg_constraint WHERE conrelid = (SELECT oid FROM pg_class WHERE relname = 'labor_organization_type') AND conname = 'labor_organization_type_unique_name' AND contype = 'u';

ROLLBACK;
