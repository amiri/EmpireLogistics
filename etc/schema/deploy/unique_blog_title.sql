-- Deploy unique_blog_title

BEGIN;

    ALTER TABLE blog ADD CONSTRAINT blog_url_title_unique UNIQUE (url_title);

COMMIT;
