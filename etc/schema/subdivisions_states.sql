drop table if exists subdivisions_states cascade;
create table subdivisions_states (
    subdivision integer not null,
    state integer not null,
    primary key (subdivision, state)
);
alter table subdivisions_states add foreign key ("state") references states("id");
alter table subdivisions_states add foreign key ("subdivision") references subdivisions("id");
