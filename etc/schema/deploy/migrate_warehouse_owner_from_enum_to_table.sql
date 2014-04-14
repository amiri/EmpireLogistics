-- Deploy migrate_warehouse_owner_from_enum_to_table

BEGIN;

    CREATE TEMPORARY TABLE tmp_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse;
    CREATE TEMPORARY TABLE tmp_warehouse_walmart WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse_walmart;
    CREATE TEMPORARY TABLE tmp_warehouse_work_stoppage WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse_work_stoppage;
    CREATE TEMPORARY TABLE tmp_warehouse_address WITH(OIDS) ON COMMIT DROP AS SELECT * FROM warehouse_address;
    CREATE TEMPORARY TABLE tmp_labor_organization_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_warehouse;
    CREATE TEMPORARY TABLE tmp_company_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM company_warehouse;

    ALTER TABLE tmp_warehouse ALTER COLUMN owner SET DATA TYPE TEXT;
    ALTER TABLE tmp_warehouse ALTER COLUMN status SET DATA TYPE TEXT;
    DROP TYPE IF EXISTS warehouse_owner cascade;
    DROP TYPE IF EXISTS warehouse_status cascade;

    CREATE TABLE warehouse_owner (
        id serial not null primary key,
        create_time timestamptz not null default now(),
        update_time timestamptz not null default now(),
        delete_time timestamptz default null,
        name text not null
    );
    CREATE TABLE warehouse_status (
        id serial not null primary key,
        create_time timestamptz not null default now(),
        update_time timestamptz not null default now(),
        delete_time timestamptz default null,
        name text not null
    );

    INSERT INTO warehouse_owner (name) VALUES
        ('walmart'),
        ('target'),
        ('costco'),
        ('krogers'),
        ('walgreens'),
        ('home depot'),
        ('amazon'),
        ('ikea');
    INSERT INTO warehouse_status (name) VALUES
        ('open'),
        ('closed');


    UPDATE tmp_warehouse tw SET owner = wo.id FROM warehouse_owner wo WHERE tw.owner = wo.name;
    UPDATE tmp_warehouse tw SET status = wo.id FROM warehouse_status wo WHERE tw.status = wo.name;

    ALTER TABLE tmp_warehouse ALTER COLUMN owner SET DATA TYPE integer USING (owner::integer);
    ALTER TABLE tmp_warehouse ALTER COLUMN status SET DATA TYPE integer USING (status::integer);

    TRUNCATE warehouse CASCADE;

    ALTER TABLE warehouse ADD COLUMN owner integer references warehouse_owner (id);
    ALTER TABLE warehouse ADD COLUMN status integer references warehouse_status (id);
    CREATE INDEX warehouse_warehouse_owner ON warehouse (owner);
    CREATE INDEX warehouse_warehouse_status ON warehouse (status);

    INSERT INTO warehouse SELECT tw.id,tw.create_time,tw.update_time,tw.delete_time,tw.name,tw.description,tw.area,tw.date_opened,tw.latitude,tw.longitude,tw.geometry,tw.owner,tw.status FROM tmp_warehouse tw;
    INSERT INTO warehouse_walmart SELECT * FROM tmp_warehouse_walmart;
    INSERT INTO warehouse_work_stoppage SELECT * FROM tmp_warehouse_work_stoppage;
    INSERT INTO warehouse_address SELECT * FROM tmp_warehouse_address;
    INSERT INTO labor_organization_warehouse SELECT * FROM tmp_labor_organization_warehouse;
    INSERT INTO company_warehouse SELECT * FROM tmp_company_warehouse;

    CREATE TRIGGER update_time BEFORE UPDATE ON warehouse_owner FOR EACH ROW EXECUTE PROCEDURE update_timestamp();
    CREATE TRIGGER update_time BEFORE UPDATE ON warehouse_status FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

COMMIT;
