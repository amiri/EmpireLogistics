-- Verify geo_rels_to_address

BEGIN;

    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'address' and column_name = 'city' and data_type = 'integer';
    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'address' and column_name = 'state' and data_type = 'integer';
    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'address' and column_name = 'postal_code' and data_type = 'integer';
    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'address' and column_name = 'country' and data_type = 'integer' and is_nullable = 'NO';
    SELECT 1/COUNT(*) column_name from information_schema.columns where table_name = 'address' and column_name = 'street_address' and data_type = 'text' and is_nullable = 'NO';

ROLLBACK;
