-- Revert geo_rels_to_port

BEGIN;

    alter table port drop constraint port_country_fkey;
    ALTER TABLE port ALTER COLUMN country SET DATA TYPE TEXT USING (country::text);
    UPDATE port p SET country = co.iso_alpha2 FROM country co WHERE p.country::integer = co.id;

COMMIT;
