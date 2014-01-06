drop table if exists subdivisions cascade;
create table subdivisions (
    id serial primary key not null,
    name text,
    full_name text,
    wmark text,
    subdivision_type text,
    comments text
);
create index subdiv_name_idx on subdivisions (name);
create index subdiv_wmark_idx on subdivisions (wmark);
