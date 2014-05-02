-- Verify not_nullable_citation_number

BEGIN;

    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'citation_number' and table_name = 'osha_citation' and is_nullable = 'NO';

ROLLBACK;
