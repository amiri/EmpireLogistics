-- Verify blog_publish_time

BEGIN;

    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'publish_time' and table_name = 'blog';

ROLLBACK;
