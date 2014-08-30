-- Deploy blog_publish_time

BEGIN;

    alter table blog add column publish_time timestamptz default null;

COMMIT;
