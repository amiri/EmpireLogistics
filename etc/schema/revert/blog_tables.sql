-- Revert blog_tables

BEGIN;

    drop table if exists blog cascade;

COMMIT;
