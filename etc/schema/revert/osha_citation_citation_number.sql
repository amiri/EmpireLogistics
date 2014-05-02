-- Revert osha_citation_citation_number

BEGIN;

    alter table osha_citation drop column citation_number;

COMMIT;
