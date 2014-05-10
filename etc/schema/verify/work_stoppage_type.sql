-- Verify work_stoppage_type

BEGIN;

    select 1/count(*) from work_stoppage_type;
    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'work_stoppage_type' and table_name = 'work_stoppage' and is_nullable = 'NO';

ROLLBACK;
