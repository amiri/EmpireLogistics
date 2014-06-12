-- Deploy media_uuid

BEGIN;

    alter table media rename column url to uuid;
    alter table media alter uuid type uuid using (uuid::uuid);
    create index on media (uuid);
    ALTER TABLE media ADD CONSTRAINT unique_uuid UNIQUE (uuid);

COMMIT;
