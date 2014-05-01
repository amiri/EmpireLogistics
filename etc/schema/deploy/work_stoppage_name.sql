-- Deploy work_stoppage_name

BEGIN;

    alter table work_stoppage add column name text not null;
    alter table work_stoppage add constraint work_stoppage_unique_name UNIQUE (name);

COMMIT;
