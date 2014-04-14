-- Revert migrate_company_type_from_enum

BEGIN;

    CREATE TEMPORARY TABLE tmp_company WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company;
    CREATE TEMPORARY TABLE tmp_company_address WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_address;
    CREATE TEMPORARY TABLE tmp_company_osha_citation WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_osha_citation;
    CREATE TEMPORARY TABLE tmp_company_nlrb_decision WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_nlrb_decision;
    CREATE TEMPORARY TABLE tmp_company_port WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_port;
    CREATE TEMPORARY TABLE tmp_company_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_warehouse;
    CREATE TEMPORARY TABLE tmp_company_rail_node WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_rail_node;

    ALTER TABLE tmp_company ALTER COLUMN company_type SET DATA TYPE TEXT;
    UPDATE tmp_company te SET company_type = ot.name FROM company_type ot WHERE te.company_type::integer = ot.id;

    DROP TABLE company_type cascade;

    CREATE TYPE company_type AS ENUM ('3PL', 'commercial', 'financial', 'industrial');

    ALTER TABLE tmp_company ALTER COLUMN company_type SET DATA TYPE company_type USING (company_type::company_type);

    TRUNCATE company CASCADE;

    ALTER TABLE company DROP COLUMN company_type;
    ALTER TABLE company ADD COLUMN company_type company_type;
    CREATE INDEX company_company_type ON company (company_type);

    INSERT INTO company SELECT tc.id,tc.create_time,tc.update_time,tc.delete_time,tc.name,tc.description,tc.company_type FROM tmp_company tc;
    INSERT INTO company_address SELECT * FROM tmp_company_address;
    INSERT INTO company_osha_citation SELECT * FROM tmp_company_osha_citation;
    INSERT INTO company_nlrb_decision SELECT * FROM tmp_company_nlrb_decision;
    INSERT INTO company_port SELECT * FROM tmp_company_port;
    INSERT INTO company_warehouse SELECT * FROM tmp_company_warehouse;
    INSERT INTO company_rail_node SELECT * FROM tmp_company_rail_node;

COMMIT;
