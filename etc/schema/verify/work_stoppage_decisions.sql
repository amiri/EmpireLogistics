-- Verify work_stoppage_decisions

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'work_stoppage_nlrb_decision';
    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'work_stoppage_osha_citation';

ROLLBACK;
