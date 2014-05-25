-- Deploy geo_rels_to_port

BEGIN;

    update port p set country = 'UM' where country in ('XU','QM','QW');
    update port p set country = 'SJ' where country = 'XR';
    UPDATE port p SET country = co.id FROM country co WHERE p.country = co.iso_alpha2;

    ALTER TABLE port ALTER COLUMN country SET DATA TYPE INTEGER USING (country::integer);
    ALTER TABLE port ALTER COLUMN country SET NOT NULL;
    alter table port add foreign key (country) references country(id) on delete cascade;

COMMIT;
