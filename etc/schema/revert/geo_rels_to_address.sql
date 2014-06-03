-- Revert geo_rels_to_address

BEGIN;

    alter table address drop constraint address_city_fkey;
    alter table address drop constraint address_state_fkey;
    alter table address drop constraint address_postal_code_fkey;
    alter table address drop constraint address_country_fkey;

    alter table address alter column city set data type text using (city::text);
    alter table address alter column state set data type text using (state::text);
    alter table address alter column postal_code set data type text using (postal_code::text);
    alter table address alter column country set data type text using (country::text);

    UPDATE address a SET city = ci.name_ascii FROM city ci WHERE a.city::integer = ci.id;
    UPDATE address a SET state = s.name_ascii FROM state s WHERE a.state::integer = s.id;
    UPDATE address a SET postal_code = pc.postal_code FROM postal_code pc WHERE a.postal_code::integer = pc.id;
    UPDATE address a SET country = co.iso_alpha2 FROM country co WHERE a.country::integer = co.id;


COMMIT;
