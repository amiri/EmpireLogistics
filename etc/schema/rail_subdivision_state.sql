drop table if exists rail_subdivision_state cascade;
create table rail_subdivision_state (
    subdivision integer not null,
    state integer not null,
    primary key (subdivision, state)
);
alter table rail_subdivision_state add foreign key ("state") references state("id");
alter table rail_subdivision_state add foreign key ("subdivision") references rail_subdivision("id");
