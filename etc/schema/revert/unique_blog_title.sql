-- Revert unique_blog_title

BEGIN;

    ALTER TABLE blog DROP CONSTRAINT blog_url_title_unique;

COMMIT;
