-- Verify alter_update_time

BEGIN;

SELECT 1/
    CASE
        WHEN (
        SELECT COUNT(column_default)
            FROM information_schema.columns
            WHERE table_name IN (
                SELECT table_name FROM information_schema.columns
                WHERE column_name='update_time')
                  AND column_name = 'update_time'
                  AND column_default NOT LIKE '%now()%'
        ) > 0 THEN 0
        ELSE 1
    END
;

ROLLBACK;
