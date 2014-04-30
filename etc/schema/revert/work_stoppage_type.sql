-- Revert work_stoppage_type

BEGIN;

    alter table work_stoppage drop column if exists work_stoppage_type cascade;
    drop table if exists work_stoppage_type cascade;
    delete from object_type where name = 'work_stoppage_type';

COMMIT;
