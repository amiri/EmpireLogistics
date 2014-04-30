-- Verify object_types_for_labor_org_and_company_types

BEGIN;

    select 1/count(*) from object_type where name = 'labor_organization_type';
    select 1/count(*) from object_type where name = 'company_type';

ROLLBACK;
