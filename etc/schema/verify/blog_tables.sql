-- Verify blog_tables

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'blog';

ROLLBACK;
