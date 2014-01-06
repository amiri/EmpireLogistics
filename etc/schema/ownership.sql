drop sequence if exists ownership_id_seq;
drop table if exists ownership cascade;
create table ownership (
    id serial primary key not null,
    aar_code integer,
    name text,
    family text,
    history text,
    flag text,
    reporting_mark text
);
CREATE INDEX reporting_mark_idx ON ownership (reporting_mark);
CREATE INDEX name_idx ON ownership (name);
