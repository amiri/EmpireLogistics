drop sequence if exists rail_ownership_id_seq cascade;
drop table if exists rail_ownership cascade;
create table rail_ownership (
    id serial primary key not null,
    aar_code integer,
    name text,
    family text,
    history text,
    flag text,
    reporting_mark text
);
CREATE INDEX reporting_mark_idx ON rail_ownership (reporting_mark);
CREATE INDEX name_idx ON rail_ownership (name);
