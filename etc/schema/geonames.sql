-- timezone
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

INSERT INTO timezone (
    name,
    gmt_offset,
    dst_offset,
    raw_offset
) SELECT
    timezoneid,
    gmt_offset,
    dst_offset,
    raw_offset
FROM timezones
;

-- timezone
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

INSERT INTO continent (
    name,
    code,
    geonameid,
    alternate_names
) SELECT
    c.name,
    c.code,
    c.geonameid,
    g.alternatenames
FROM continentcodes c
    LEFT JOIN geoname g
        ON c.geonameid = g.geonameid
;

-- currency
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
INSERT INTO currency (code,name,symbol) VALUES
    ('AED', 'Dirham', 'د.إ' ),
    ('AFN', 'Afghani', '؋' ),
    ('ALL', 'Lek', 'L' ),
    ('AMD', 'Dram', 'դր.' ),
    ('ANG', 'Guilder', 'ƒ' ),
    ('AOA', 'Kwanza', 'Kz' ),
    ('ARS', 'Peso', '$' ),
    ('AUD', 'Dollar', '$' ),
    ('AWG', 'Guilder', 'ƒ' ),
    ('AZN', 'Manat', 'm' ),
    ('BAM', 'Marka', 'KM' ),
    ('BBD', 'Dollar', '$' ),
    ('BDT', 'Taka', '৳' ),
    ('BGN', 'Lev', 'лв' ),
    ('BHD', 'Dinar', 'ب.د' ),
    ('BIF', 'Franc', 'Fr' ),
    ('BMD', 'Dollar', '$' ),
    ('BND', 'Dollar', '$' ),
    ('BOB', 'Boliviano', 'Bs.' ),
    ('BRL', 'Real', 'R$' ),
    ('BSD', 'Dollar', '$' ),
    ('BTN', 'Ngultrum', 'Nu' ),
    ('BWP', 'Pula', 'P' ),
    ('BYR', 'Ruble', 'Br' ),
    ('BZD', 'Dollar', '$' ),
    ('CAD', 'Dollar', '$' ),
    ('CDF', 'Franc', 'Fr' ),
    ('CHF', 'Franc', 'Fr' ),
    ('CLP', 'Peso', '$' ),
    ('CNY', 'Yuan Renminbi', '¥' ),
    ('COP', 'Peso', '$' ),
    ('CRC', 'Colon', '₡' ),
    ('CUP', 'Peso', '$' ),
    ('CVE', 'Escudo', '$, Esc' ),
    ('CZK', 'Koruna', 'Kč' ),
    ('DJF', 'Franc', 'Fr' ),
    ('DKK', 'Krone', 'kr' ),
    ('DOP', 'Peso', '$' ),
    ('DZD', 'Dinar', 'د.ج' ),
    ('EEK', NULL, 'KR' ),
    ('EGP', 'Pound', '£,ج.م' ),
    ('ERN', 'Nakfa', 'Nfk' ),
    ('ETB', 'Birr', 'Br' ),
    ('EUR', 'Euro', '€' ),
    ('FJD', 'Dollar', '$' ),
    ('FKP', 'Pound', '£' ),
    ('GBP', 'Pound', '£' ),
    ('GEL', 'Lari', 'ლ' ),
    ('GHS', 'Cedi', '₵' ),
    ('GIP', 'Pound', '£' ),
    ('GMD', 'Dalasi', 'D' ),
    ('GNF', 'Franc', 'Fr' ),
    ('GTQ', 'Quetzal', 'Q' ),
    ('GYD', 'Dollar', '$' ),
    ('HKD', 'Dollar', '$' ),
    ('HNL', 'Lempira', 'L' ),
    ('HRK', 'Kuna', 'kn' ),
    ('HTG', 'Gourde', 'G' ),
    ('HUF', 'Forint', 'Ft' ),
    ('IDR', 'Rupiah', 'Rp' ),
    ('ILS', 'Shekel', '₪' ),
    ('INR', 'Rupee', '₨' ),
    ('IQD', 'Dinar', 'ع.د' ),
    ('IRR', 'Rial', '﷼' ),
    ('ISK', 'Krona', 'kr' ),
    ('JMD', 'Dollar', '$' ),
    ('JOD', 'Dinar', 'د.ا' ),
    ('JPY', 'Yen', '¥' ),
    ('KES', 'Shilling', 'Sh' ),
    ('KGS', 'Som', 'лв' ),
    ('KHR', 'Riels', '៛' ),
    ('KMF', 'Franc', 'Fr' ),
    ('KPW', 'Won', '₩' ),
    ('KRW', 'Won', '₩' ),
    ('KWD', 'Dinar', 'د.ك' ),
    ('KYD', 'Dollar', '$' ),
    ('KZT', 'Tenge', 'Т' ),
    ('LAK', 'Kip', '₭' ),
    ('LBP', 'Pound', 'ل.ل' ),
    ('LKR', 'Rupee', 'ரூ' ),
    ('LRD', 'Dollar', '$' ),
    ('LSL', 'Loti', 'L' ),
    ('LTL', 'Litas', 'Lt' ),
    ('LVL', NULL, 'Ls' ),
    ('LYD', 'Dinar', 'ل.د' ),
    ('MAD', 'Dirham', 'د.م.' ),
    ('MDL', 'Leu', 'L' ),
    ('MGA', 'Ariary', 'Ar' ),
    ('MKD', 'Denar', 'ден' ),
    ('MMK', 'Kyat', 'K' ),
    ('MNT', 'Tugrik', '₮' ),
    ('MOP', 'Pataca', 'P' ),
    ('MRO', 'Ouguiya', 'UM' ),
    ('MUR', 'Rupee', '₨' ),
    ('MVR', 'Rufiyaa', 'ރ.' ),
    ('MWK', 'Kwacha', 'MK' ),
    ('MXN', 'Peso', '$' ),
    ('MYR', 'Ringgit', 'RM' ),
    ('MZN', 'Metical', 'MT' ),
    ('NAD', 'Dollar', '$' ),
    ('NGN', 'Naira', '₦' ),
    ('NIO', 'Cordoba', 'C$' ),
    ('NOK', 'Krone', 'kr' ),
    ('NPR', 'Rupee', '₨' ),
    ('NZD', 'Dollar', '$' ),
    ('OMR', 'Rial', 'ر.ع.' ),
    ('PAB', 'Balboa', 'B/.' ),
    ('PEN', 'Sol', 'S/.' ),
    ('PGK', 'Kina', 'K' ),
    ('PHP', 'Peso', '₱' ),
    ('PKR', 'Rupee', '₨' ),
    ('PLN', 'Zloty', 'zł' ),
    ('PYG', 'Guarani', '₲' ),
    ('QAR', 'Rial', 'ر.ق' ),
    ('RON', 'Leu', 'RON' ),
    ('RSD', 'Dinar', 'RSD' ),
    ('RUB', 'Ruble', 'р.' ),
    ('RWF', 'Franc', 'Fr' ),
    ('SAR', 'Rial', 'ر.س' ),
    ('SBD', 'Dollar', '$' ),
    ('SCR', 'Rupee', '₨' ),
    ('SDG', 'Pound', 'S$' ),
    ('SEK', 'Krona', 'kr' ),
    ('SGD', 'Dollar', '$' ),
    ('SHP', 'Pound', '£' ),
    ('SLL', 'Leone', 'Le' ),
    ('SOS', 'Shilling', 'Sh' ),
    ('SRD', 'Dollar', '$' ),
    ('STD', 'Dobra', 'Db' ),
    ('SYP', 'Pound', '£, ل.س' ),
    ('SZL', 'Lilangeni', 'L' ),
    ('THB', 'Baht', '฿' ),
    ('TJS', 'Somoni', 'ЅМ' ),
    ('TMT', 'Manat', 'm' ),
    ('TND', 'Dinar', 'د.ت' ),
    ('TOP', $$Pa'anga$$, 'T$' ),
    ('TRY', 'Lira', '₤' ),
    ('TTD', 'Dollar', '$' ),
    ('TWD', 'Dollar', '$' ),
    ('TZS', 'Shilling', 'Sh' ),
    ('UAH', 'Hryvnia', '₴' ),
    ('UGX', 'Shilling', 'Sh' ),
    ('USD', 'Dollar', '$' ),
    ('UYU', 'Peso', '$' ),
    ('UZS', 'Som', 'лв' ),
    ('VEF', 'Bolivar', 'Bs' ),
    ('VND', 'Dong', '₫' ),
    ('VUV', 'Vatu', 'Vt' ),
    ('WST', 'Tala', 'T' ),
    ('XAF', 'Franc', 'Fr' ),
    ('XCD', 'Dollar', '$' ),
    ('XOF', 'Franc', 'Fr' ),
    ('XPF', 'Franc', 'Fr' ),
    ('YER', 'Rial', '﷼' ),
    ('ZAR', 'Rand', 'R' ),
    ('ZMK', 'Kwacha', 'ZK' ),
    ('ZWL', 'Dollar', '$')
;

-- '

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

INSERT INTO country (
    name,
    official_name,
    official_name_ascii,
    iso_alpha2,
    iso_alpha3,
    iso_id,
    fips_code,
    area_kilometers,
    population,
    continent,
    tld,
    currency,
    phone,
    postal,
    postalregex,
    languages,
    geonameid,
    neighbours,
    alternate_names
)
SELECT
    c.country,
    g.name,
    g.asciiname,
    c.iso_alpha2,
    c.iso_alpha3,
    c.iso_numeric,
    c.fips_code,
    c.areainsqkm,
    c.population,
    co.id,
    c.tld,
    cu.id,
    c.phone,
    c.postal,
    c.postalregex,
    c.languages,
    c.geonameid,
    c.neighbours,
    g.alternatenames
FROM countryinfo c
    LEFT JOIN geoname g
        ON c.geonameid = g.geonameid
    LEFT JOIN continent co
        ON c.continent = co.code
    LEFT JOIN currency cu
        ON c.currency_code = cu.code
;

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
    admin1 character varying(20),
    country integer not null references country(id) on delete cascade,
    population integer,
    timezone integer not null references timezone(id)
);
ALTER TABLE state ADD CONSTRAINT unique_state_country_name UNIQUE (name,country);
create index on state (name);
create index on state (name_ascii);
create index on state (admin1);
create index on state (country);

INSERT INTO state (
    name,
    name_ascii,
    geonameid,
    alternate_names,
    admin1,
    country,
    population,
    timezone
) SELECT
    g.name,
    g.asciiname,
    g.geonameid,
    g.alternatenames,
    g.admin1,
    c.id,
    g.population,
    t.id
FROM geoname g
    LEFT JOIN country c
        ON g.country = c.iso_alpha2
    LEFT JOIN timezone t
        ON g.timezone = t.name
WHERE g.fcode = 'ADM1';

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

INSERT INTO city (
    name,
    name_ascii,
    geonameid,
    alternate_names,
    latitude,
    longitude,
    country,
    admin1,
    admin2,
    admin3,
    admin4,
    fcode,
    state,
    population,
    timezone,
    geometry
) SELECT DISTINCT ON(g.name,g.asciiname,g.latitude,g.longitude,s.id,c.id)
    g.name,
    g.asciiname,
    g.geonameid,
    g.alternatenames,
    g.latitude,
    g.longitude,
    c.id,
    g.admin1,
    g.admin2,
    g.admin3,
    g.admin4,
    g.fcode,
    s.id,
    g.population,
    t.id,
    g.the_geom
FROM cities1000 g
    LEFT JOIN country c
        ON g.country = c.iso_alpha2
    LEFT JOIN state s
        ON (
            g.admin1 = s.admin1
        AND s.country = c.id
        )
    LEFT JOIN timezone t
        ON g.timezone = t.name
WHERE g.fcode like 'PPL%';

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

INSERT INTO postal_code (
    postal_code,
    latitude,
    longitude,
    state,
    country
) SELECT
    DISTINCT ON(p.countrycode,p.postalcode)
      p.postalcode AS postal_code
    , p.latitude
    , p.longitude
    , s.id AS state
    , c.id AS country
FROM
    postalcodes p
LEFT JOIN
    country c
        ON p.countrycode = c.iso_alpha2
LEFT JOIN
    state s
        ON (
            (
                   (s.name ilike '%' || admin1name || '%')
                OR (s.name_ascii ilike '%' || admin1name || '%')
            )
            AND s.country = c.id
        )
ORDER BY p.countrycode,p.postalcode;

UPDATE postal_code SET geometry = ST_PointFromText('POINT(' || longitude || ' ' || latitude || ')', 900913);
