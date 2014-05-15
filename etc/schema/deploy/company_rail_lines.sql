-- Deploy company_rail_lines

BEGIN;

    create table company_rail_line (
        id serial not null primary key,
        create_time timestamptz not null default now(),
        update_time timestamptz not null default now(),
        delete_time timestamptz default null,
        company integer not null,
        rail_line integer not null,
        unique (company,rail_line)
    );
    create index on company_rail_line (company);
    create index on company_rail_line (rail_line);
    alter table company_rail_line add foreign key (company) references company(id) on delete cascade;
    alter table company_rail_line add foreign key (rail_line) references rail_line(id) on delete cascade;
    create trigger update_time before update on company_rail_line for each row execute procedure update_timestamp();
    INSERT INTO object_type (name) VALUES ('company_rail_line');

COMMIT;
