-- Deploy unique_names_on_labor_org_and_company_types

BEGIN;

    ALTER TABLE company_type ADD CONSTRAINT company_type_unique_name UNIQUE (name);
    ALTER TABLE labor_organization_type ADD CONSTRAINT labor_organization_type_unique_name UNIQUE (name);

COMMIT;
