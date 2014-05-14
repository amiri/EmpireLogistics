-- Deploy work_stoppage_decisions

BEGIN;

create table work_stoppage_nlrb_decision (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    work_stoppage integer not null,
    nlrb_decision integer not null,
    unique (work_stoppage,nlrb_decision)
);
create index on work_stoppage_nlrb_decision (work_stoppage);
create index on work_stoppage_nlrb_decision (nlrb_decision);
alter table work_stoppage_nlrb_decision add foreign key (work_stoppage) references work_stoppage(id) on delete cascade;
alter table work_stoppage_nlrb_decision add foreign key (nlrb_decision) references nlrb_decision(id) on delete cascade;
create trigger update_time before update on work_stoppage_nlrb_decision for each row execute procedure update_timestamp();
INSERT INTO object_type (name) VALUES ('work_stoppage_nlrb_decision');

create table work_stoppage_osha_citation (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    work_stoppage integer not null,
    osha_citation integer not null,
    unique (work_stoppage,osha_citation)
);
create index on work_stoppage_osha_citation (work_stoppage);
create index on work_stoppage_osha_citation (osha_citation);
alter table work_stoppage_osha_citation add foreign key (work_stoppage) references work_stoppage(id) on delete cascade;
alter table work_stoppage_osha_citation add foreign key (osha_citation) references osha_citation(id) on delete cascade;
create trigger update_time before update on work_stoppage_osha_citation for each row execute procedure update_timestamp();
INSERT INTO object_type (name) VALUES ('work_stoppage_osha_citation');




COMMIT;
