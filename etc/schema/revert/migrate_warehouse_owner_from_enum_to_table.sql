-- Revert migrate_warehouse_owner_from_enum_to_table

BEGIN;

    CREATE TEMPORARY TABLE tmp_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse;
    CREATE TEMPORARY TABLE tmp_warehouse_walmart WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse_walmart;
    CREATE TEMPORARY TABLE tmp_warehouse_work_stoppage WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse_work_stoppage;
    CREATE TEMPORARY TABLE tmp_warehouse_address WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse_address;
    CREATE TEMPORARY TABLE tmp_labor_organization_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_warehouse;
    CREATE TEMPORARY TABLE tmp_company_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_warehouse;

    ALTER TABLE tmp_warehouse ALTER COLUMN owner SET DATA TYPE TEXT;
    ALTER TABLE tmp_warehouse ALTER COLUMN status SET DATA TYPE TEXT;
    UPDATE tmp_warehouse tw SET owner = wo.name FROM warehouse_owner wo WHERE tw.owner::integer = wo.id;
    UPDATE tmp_warehouse tw SET status = wo.name FROM warehouse_status wo WHERE tw.status::integer = wo.id;

    DROP TABLE warehouse_owner cascade;
    DROP TABLE warehouse_status cascade;

    CREATE TYPE warehouse_owner AS ENUM ('walmart', 'target', 'costco', 'krogers', 'walgreens', 'home depot', 'amazon', 'ikea');
    CREATE TYPE warehouse_status AS ENUM ('open', 'closed');

    ALTER TABLE tmp_warehouse ALTER COLUMN owner SET DATA TYPE warehouse_owner USING (owner::warehouse_owner);
    ALTER TABLE tmp_warehouse ALTER COLUMN status SET DATA TYPE warehouse_status USING (status::warehouse_status);

    TRUNCATE warehouse CASCADE;

    ALTER TABLE warehouse DROP COLUMN owner;
    ALTER TABLE warehouse DROP COLUMN status;
    ALTER TABLE warehouse ADD COLUMN owner warehouse_owner;
    ALTER TABLE warehouse ADD COLUMN status warehouse_status;
    CREATE INDEX warehouse_warehouse_owner ON warehouse (owner);
    CREATE INDEX warehouse_warehouse_status ON warehouse (status);

    INSERT INTO warehouse SELECT tw.id,tw.create_time,tw.update_time,tw.delete_time,tw.name,tw.description,tw.area,tw.date_opened,tw.latitude,tw.longitude,tw.geometry,tw.owner,tw.status FROM tmp_warehouse tw;
    INSERT INTO warehouse_walmart SELECT * FROM tmp_warehouse_walmart;
    INSERT INTO warehouse_work_stoppage SELECT * FROM tmp_warehouse_work_stoppage;
    INSERT INTO warehouse_address SELECT * FROM tmp_warehouse_address;
    INSERT INTO labor_organization_warehouse SELECT * FROM tmp_labor_organization_warehouse;
    INSERT INTO company_warehouse SELECT * FROM tmp_company_warehouse;

COMMIT;
