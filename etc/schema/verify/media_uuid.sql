-- Verify media_uuid

BEGIN;

    SELECT 1/COUNT(*) table_name from information_schema.columns where table_name = 'media' and column_name = 'uuid';

ROLLBACK;
