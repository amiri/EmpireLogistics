-- Deploy blog_tables

BEGIN;

create table blog (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    title text not null,
    url_title text not null,
    body text not null,
    author integer not null
);
create index on blog("author");
create index on blog("url_title");
alter table blog add foreign key (author) references "user"(id) on delete cascade;
create trigger update_time before update on blog for each row execute procedure update_timestamp();
INSERT INTO object_type (name) VALUES ('blog');

COMMIT;
