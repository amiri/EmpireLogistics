-- Verify port_rail_yard_descriptions

BEGIN;

    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'description' and table_name = 'port';
    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'description' and table_name = 'rail_node';
    SELECT 1/count(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'description' and table_name = 'rail_line';

ROLLBACK;
