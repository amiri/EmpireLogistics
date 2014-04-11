-- Deploy port_name_lat_lon

BEGIN;

    delete from port where id in (
        SELECT id FROM (
            SELECT id, row_number() over (partition BY port_name, latitude, longitude ORDER BY id) AS rnum FROM port
        ) t WHERE t.rnum > 1
    );

    alter table port add constraint port_name_lat_lon unique (port_name,latitude,longitude);

COMMIT;
