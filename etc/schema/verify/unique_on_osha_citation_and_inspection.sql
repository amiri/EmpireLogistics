-- Verify unique_on_osha_citation_and_inspection

BEGIN;

SELECT 1/COUNT(contype) FROM pg_constraint WHERE conrelid = (SELECT oid FROM pg_class WHERE relname = 'osha_citation') AND conname = 'osha_citation_inspection_and_citation_unique' AND contype = 'u';

ROLLBACK;
