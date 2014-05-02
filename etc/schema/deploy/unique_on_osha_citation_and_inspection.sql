-- Deploy unique_on_osha_citation_and_inspection

BEGIN;

    ALTER TABLE osha_citation ADD CONSTRAINT osha_citation_inspection_and_citation_unique UNIQUE (inspection_number,citation_number);

COMMIT;
