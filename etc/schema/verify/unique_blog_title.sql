-- Verify unique_blog_title

BEGIN;

    SELECT 1/COUNT(contype) FROM pg_constraint WHERE conrelid = (SELECT oid FROM pg_class WHERE relname = 'blog') AND conname = 'blog_url_title_unique' AND contype = 'u';

ROLLBACK;
