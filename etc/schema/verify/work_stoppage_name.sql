-- Verify work_stoppage_name

BEGIN;

    SELECT 1/COUNT(contype) FROM pg_constraint WHERE conrelid = (SELECT oid FROM pg_class WHERE relname = 'work_stoppage') AND conname = 'work_stoppage_unique_name' AND contype = 'u';

ROLLBACK;
