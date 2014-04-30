-- Revert object_types_for_labor_org_and_company_types

BEGIN;

    delete from object_type where name = 'labor_organization_type';
    delete from object_type where name = 'company_type';

COMMIT;
