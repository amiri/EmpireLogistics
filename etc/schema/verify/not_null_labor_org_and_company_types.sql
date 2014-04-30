-- Verify not_null_labor_org_and_company_types

BEGIN;

    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'organization_type' and table_name = 'labor_organization' and is_nullable = 'NO';
    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'company_type' and table_name = 'company' and is_nullable = 'NO';

ROLLBACK;
