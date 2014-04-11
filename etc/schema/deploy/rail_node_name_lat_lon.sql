-- Deploy rail_node_name_lat_lon

BEGIN;

    delete from rail_node where id in (
        SELECT id FROM (
            SELECT id, row_number() over (partition BY name, latitude, longitude ORDER BY id) AS rnum FROM rail_node
        ) t WHERE t.rnum > 1
    );

    alter table rail_node add constraint rail_node_name_lat_lon unique (name,latitude,longitude);

COMMIT;
