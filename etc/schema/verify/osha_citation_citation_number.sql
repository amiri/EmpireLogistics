-- Verify osha_citation_citation_number

BEGIN;


    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'citation_number' and table_name = 'osha_citation';

ROLLBACK;
