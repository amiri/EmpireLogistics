-- Revert work_stoppage_name

BEGIN;

    alter table work_stoppage drop column name cascade;

COMMIT;
