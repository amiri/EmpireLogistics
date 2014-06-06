-- Deploy media_rels

BEGIN;

    create table port_media (
        port integer not null,
        media integer not null,
        primary key (port,media)
    );
    create index on port_media (port);
    create index on port_media (media);
    alter table port_media add foreign key (port) references port(id) on delete cascade;
    alter table port_media add foreign key (media) references media(id) on delete cascade;

    create table rail_node_media (
        rail_node integer not null,
        media integer not null,
        primary key (rail_node,media)
    );
    create index on rail_node_media (rail_node);
    create index on rail_node_media (media);
    alter table rail_node_media add foreign key (rail_node) references rail_node(id) on delete cascade;
    alter table rail_node_media add foreign key (media) references media(id) on delete cascade;

    create table warehouse_media (
        warehouse integer not null,
        media integer not null,
        primary key (warehouse,media)
    );
    create index on warehouse_media (warehouse);
    create index on warehouse_media (media);
    alter table warehouse_media add foreign key (warehouse) references warehouse(id) on delete cascade;
    alter table warehouse_media add foreign key (media) references media(id) on delete cascade;


COMMIT;
