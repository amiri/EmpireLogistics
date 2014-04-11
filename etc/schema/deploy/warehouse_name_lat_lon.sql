-- Deploy warehouse_name_lat_lon

BEGIN;

    delete from warehouse where id in (
        SELECT id FROM (
            SELECT id, row_number() over (partition BY name, latitude, longitude ORDER BY id) AS rnum FROM warehouse
        ) t WHERE t.rnum > 1
    );

    alter table warehouse add constraint warehouse_name_lat_lon unique (name,latitude,longitude);

COMMIT;
