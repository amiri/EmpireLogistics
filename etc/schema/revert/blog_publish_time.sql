-- Revert blog_publish_time

BEGIN;

    alter table blog drop column publish_time cascade;

COMMIT;
