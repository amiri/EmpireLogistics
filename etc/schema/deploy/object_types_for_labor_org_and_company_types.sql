-- Deploy object_types_for_labor_org_and_company_types

BEGIN;

    insert into object_type (name) values ('labor_organization_type');
    insert into object_type (name) values ('company_type');

COMMIT;
