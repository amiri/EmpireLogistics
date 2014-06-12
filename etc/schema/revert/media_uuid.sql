-- Revert media_uuid

BEGIN;

    alter table media rename column uuid to url;
    alter table media alter url type text using (url::text);
    drop index if exists media_uuid_idx;
    ALTER TABLE media DROP CONSTRAINT unique_uuid;

COMMIT;
