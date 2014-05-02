-- Deploy unique_company_name

BEGIN;

    ALTER TABLE company ADD CONSTRAINT company_name_unique UNIQUE (name);

COMMIT;
