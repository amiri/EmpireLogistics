drop table if exists rail_subdivision cascade;
create table rail_subdivision (
    id serial primary key not null,
    name text,
    full_name text,
    wmark text,
    subdivision_type text,
    comments text
);
create index subdiv_name_idx on rail_subdivision (name);
create index subdiv_wmark_idx on rail_subdivision (wmark);
