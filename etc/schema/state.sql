drop sequence if exists state_id_seq;
drop table if exists state cascade;
create table state (
    id serial primary key not null,
    abbreviation text,
    name text
);
CREATE INDEX state_abbreviation_idx ON state (abbreviation);
CREATE INDEX state_name_idx ON state (name);
