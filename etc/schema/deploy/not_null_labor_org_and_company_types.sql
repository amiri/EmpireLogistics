-- Deploy not_null_labor_org_and_company_types

BEGIN;

    alter table labor_organization alter column organization_type set not null;
    alter table company alter column company_type set not null;

COMMIT;
