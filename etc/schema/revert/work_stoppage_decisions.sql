-- Revert work_stoppage_decisions

BEGIN;

drop table if exists work_stoppage_nlrb_decision cascade;
drop table if exists work_stoppage_osha_decision cascade;

COMMIT;
