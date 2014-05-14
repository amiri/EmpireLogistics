-- Deploy labor_organization_rail_lines

BEGIN;

    create table labor_organization_rail_line (
        id serial not null primary key,
        create_time timestamptz not null default now(),
        update_time timestamptz not null default now(),
        delete_time timestamptz default null,
        labor_organization integer not null,
        rail_line integer not null,
        unique (labor_organization,rail_line)
    );
    create index on labor_organization_rail_line (labor_organization);
    create index on labor_organization_rail_line (rail_line);
    alter table labor_organization_rail_line add foreign key (labor_organization) references labor_organization(id) on delete cascade;
    alter table labor_organization_rail_line add foreign key (rail_line) references rail_line(id) on delete cascade;
    create trigger update_time before update on labor_organization_rail_line for each row execute procedure update_timestamp();
    INSERT INTO object_type (name) VALUES ('labor_organization_rail_line');

COMMIT;
