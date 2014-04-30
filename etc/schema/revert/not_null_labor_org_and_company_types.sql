-- Revert not_null_labor_org_and_company_types

BEGIN;

    alter table labor_organization alter column organization_type drop not null;
    alter table company alter column company_type drop not null;

COMMIT;
