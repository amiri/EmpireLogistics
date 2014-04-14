-- Deploy migrate_company_type_from_enum

BEGIN;

    CREATE TEMPORARY TABLE tmp_company WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company;
    CREATE TEMPORARY TABLE tmp_company_address WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_address;
    CREATE TEMPORARY TABLE tmp_company_osha_citation WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_osha_citation;
    CREATE TEMPORARY TABLE tmp_company_nlrb_decision WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_nlrb_decision;
    CREATE TEMPORARY TABLE tmp_company_port WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_port;
    CREATE TEMPORARY TABLE tmp_company_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_warehouse;
    CREATE TEMPORARY TABLE tmp_company_rail_node WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_rail_node;

    ALTER TABLE tmp_company ALTER COLUMN company_type SET DATA TYPE TEXT;
    DROP TYPE IF EXISTS company_type cascade;

    CREATE TABLE company_type (
        id serial not null primary key,
        create_time timestamptz not null default now(),
        update_time timestamptz not null default now(),
        delete_time timestamptz default null,
        name text not null
    );

    INSERT INTO company_type (name) VALUES
        ('3PL'),
        ('commercial'),
        ('financial'),
        ('industrial');


    UPDATE tmp_company te SET company_type = o.id FROM company_type o WHERE te.company_type = o.name;

    ALTER TABLE tmp_company ALTER COLUMN company_type SET DATA TYPE integer USING (company_type::integer);

    TRUNCATE company CASCADE;

    ALTER TABLE company ADD COLUMN company_type integer references company_type (id);
    CREATE INDEX company_company_type ON company (company_type);

    INSERT INTO company SELECT tc.id,tc.create_time,tc.update_time,tc.delete_time,tc.name,tc.description,tc.company_type FROM tmp_company tc;
    INSERT INTO company_address SELECT * FROM tmp_company_address;
    INSERT INTO company_osha_citation SELECT * FROM tmp_company_osha_citation;
    INSERT INTO company_nlrb_decision SELECT * FROM tmp_company_nlrb_decision;
    INSERT INTO company_port SELECT * FROM tmp_company_port;
    INSERT INTO company_warehouse SELECT * FROM tmp_company_warehouse;
    INSERT INTO company_rail_node SELECT * FROM tmp_company_rail_node;

    CREATE TRIGGER update_time BEFORE UPDATE ON company_type FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

COMMIT;
