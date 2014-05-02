-- Revert unique_on_osha_citation_and_inspection

BEGIN;

    ALTER TABLE osha_citation DROP CONSTRAINT osha_citation_inspection_and_citation_unique;

COMMIT;
