-- Revert unique_names_on_labor_org_and_company_types

BEGIN;

    ALTER TABLE company_type DROP CONSTRAINT company_type_unique_name;
    ALTER TABLE labor_organization_type DROP CONSTRAINT labor_organization_type_unique_name;

COMMIT;
