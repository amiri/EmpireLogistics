-- Revert unique_company_name

BEGIN;

    ALTER TABLE company DROP CONSTRAINT company_name_unique;

COMMIT;
