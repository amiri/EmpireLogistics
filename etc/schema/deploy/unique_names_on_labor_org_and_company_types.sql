-- Deploy unique_names_on_labor_org_and_company_types

BEGIN;

    ALTER TABLE company_type ADD UNIQUE CONSTRAINT company_type_unique_name (name);
    ALTER TABLE labor_organization_type ADD UNIQUE CONSTRAINT labor_organization_type_unique_name (name);

COMMIT;
