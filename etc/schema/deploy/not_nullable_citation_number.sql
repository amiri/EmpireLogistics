-- Deploy not_nullable_citation_number

BEGIN;

    alter table osha_citation alter column citation_number set not null;

COMMIT;
