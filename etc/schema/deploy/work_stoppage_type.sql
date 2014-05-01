-- Deploy work_stoppage_type

BEGIN;

    create table work_stoppage_type (
        id serial not null primary key,
        create_time timestamptz not null default now(),
        update_time timestamptz not null default now(),
        delete_time timestamptz default null,
        name text not null
    );

    INSERT INTO work_stoppage_type (name) VALUES
        ('strike'),
        ('protest'),
        ('sickout'),
        ('slowdown')
    ;

    ALTER TABLE work_stoppage_type ADD CONSTRAINT work_stoppage_type_unique_name UNIQUE (name);
    alter table work_stoppage add column work_stoppage_type integer not null references work_stoppage_type(id);
    CREATE INDEX work_stoppage_work_stoppage_type ON work_stoppage (work_stoppage_type);
    insert into object_type (name) values ('work_stoppage_type');

    CREATE TRIGGER update_time BEFORE UPDATE ON work_stoppage_type FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

COMMIT;
