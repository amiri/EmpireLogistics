-- Verify unique_company_name

BEGIN;

    SELECT 1/COUNT(contype) FROM pg_constraint WHERE conrelid = (SELECT oid FROM pg_class WHERE relname = 'company') AND conname = 'company_name_unique' AND contype = 'u';

ROLLBACK;
