-- Verify port_name_lat_lon

BEGIN;

SELECT 1/count(*)
FROM   pg_constraint c
JOIN  (
       SELECT array_agg(attnum::int) AS attkey
       FROM   pg_attribute  a
       WHERE  attrelid = 'port'::regclass
       AND    attname = ANY('{port_name,latitude,longitude}') 
       ) a ON c.conkey::int[] <@ attkey AND c.conkey::int[] @> attkey
    WHERE  contype = 'u'
    AND    conrelid = 'port'::regclass;


ROLLBACK;
