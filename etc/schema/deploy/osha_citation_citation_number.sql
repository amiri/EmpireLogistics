-- Deploy osha_citation_citation_number

BEGIN;

    alter table osha_citation add column citation_number text default null;

COMMIT;
