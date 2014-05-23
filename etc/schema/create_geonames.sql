
BEGIN;

-- Alter rail_subdivision_state

ALTER TABLE rail_subdivision_state DROP CONSTRAINT rail_subdivision_state_state_fkey;
DROP INDEX rail_subdivision_state_state_idx;
ALTER TABLE rail_subdivision_state ALTER COLUMN state SET DATA TYPE TEXT;
UPDATE rail_subdivision_state sub SET state = s.abbreviation FROM state s WHERE sub.state = s.id::text;

DROP TABLE IF EXISTS timezone cascade;
CREATE TABLE timezone (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    name text not null,
    gmt_offset numeric(3,1),
    dst_offset numeric(3,1),
    raw_offset numeric(3,1)
);
ALTER TABLE timezone ADD CONSTRAINT unique_timezone_name UNIQUE (name);
create index on timezone (name);

DROP TABLE IF EXISTS continent cascade;
CREATE TABLE continent (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    name text not null,
    code character varying(2) not null,
    geonameid integer not null,
    alternate_names text
);
ALTER TABLE continent ADD CONSTRAINT unique_continent_name UNIQUE (name);
ALTER TABLE continent ADD CONSTRAINT unique_continent_code UNIQUE (code);
create index on continent (name);
create index on continent (geonameid);
create index on continent (code);

DROP TABLE IF EXISTS currency cascade;
CREATE TABLE currency (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    name text,
    code character varying(3) not null,
    symbol character varying(10) not null
);
ALTER TABLE currency ADD CONSTRAINT unique_currency_name_code UNIQUE (name,code);
create index on currency (name);
create index on currency (code);

DROP TABLE IF EXISTS country cascade;
CREATE TABLE country (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    name text not null,
    official_name text,
    official_name_ascii text,
    iso_alpha2 character varying(2),
    iso_alpha3 character varying(3),
    iso_id integer not null,
    fips_code character varying(2),
    area_kilometers integer,
    population integer,
    continent integer not null references continent(id) on delete cascade,
    tld text,
    currency integer references currency(id) on delete cascade,
    phone text,
    postal text,
    postalregex text,
    languages text,
    geonameid integer not null,
    neighbours text,
    alternate_names text
);
ALTER TABLE country ADD CONSTRAINT unique_country_name UNIQUE (name);
ALTER TABLE country ADD CONSTRAINT unique_country_official_name UNIQUE (official_name);
ALTER TABLE country ADD CONSTRAINT unique_country_official_name_ascii UNIQUE (official_name_ascii);
ALTER TABLE country ADD CONSTRAINT unique_country_iso_alpha2 UNIQUE (iso_alpha2);
ALTER TABLE country ADD CONSTRAINT unique_country_iso_alpha3 UNIQUE (iso_alpha3);
ALTER TABLE country ADD CONSTRAINT unique_country_iso_id UNIQUE (iso_id);
ALTER TABLE country ADD CONSTRAINT unique_country_name_tld UNIQUE (name,tld);
ALTER TABLE country ADD CONSTRAINT unique_country_geonameid UNIQUE (geonameid);
create index on country (name);
create index on country (continent);
create index on country (currency);
create index on country (official_name);
create index on country (official_name_ascii);
create index on country (iso_alpha2);
create index on country (iso_alpha3);
create index on country (iso_id);
create index on country (tld);
create index on country (geonameid);

DROP TABLE IF EXISTS state cascade;
CREATE TABLE state (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    name text not null,
    name_ascii text not null,
    geonameid integer not null,
    alternate_names text,
    abbreviation character varying(20),
    country integer not null references country(id) on delete cascade,
    population integer,
    timezone integer not null references timezone(id)
);
ALTER TABLE state ADD CONSTRAINT unique_state_country_name UNIQUE (name,country);
create index on state (name);
create index on state (name_ascii);
create index on state (abbreviation);
create index on state (country);

DROP TABLE IF EXISTS city cascade;
CREATE TABLE city (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    name text not null,
    name_ascii text,
    geonameid integer not null,
    alternate_names text,
    latitude double precision,
    longitude double precision,
    country integer not null references country(id) on delete cascade,
    admin1 character varying(20),
    admin2 character varying(80),
    admin3 character varying(20),
    admin4 character varying(20),
    fcode character varying(10),
    state integer references state(id) on delete cascade,
    population integer,
    timezone integer not null references timezone(id),
    geometry geometry(Point,900913)
);
create index on city (name);
create index on city (name_ascii);
create index on city (state);
create index on city (admin1);
create index on city (fcode);
create index on city (country);

DROP TABLE IF EXISTS postal_code;
CREATE TABLE postal_code (
    id serial not null primary key,
    create_time timestamptz not null default now(),
    update_time timestamptz not null default now(),
    delete_time timestamptz default null,
    postal_code text not null,
    latitude double precision,
    longitude double precision,
    state integer references state(id) on delete cascade,
    country integer not null references country(id) on delete cascade,
    geometry geometry(Point,900913)
);
ALTER TABLE postal_code ADD CONSTRAINT unique_postal_code_state_country UNIQUE (postal_code,state,country);
create index on postal_code(postal_code);
create index on postal_code(state);
create index on postal_code(country);

COMMIT;
