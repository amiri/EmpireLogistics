drop sequence if exists states_id_seq;
drop table if exists states cascade;
create table states (
    id serial primary key not null,
    abbreviation text,
    name text
);
CREATE INDEX state_abbreviation_idx ON states (abbreviation);
CREATE INDEX state_name_idx ON states (name);
