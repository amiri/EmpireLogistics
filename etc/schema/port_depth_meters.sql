drop table if exists port_depth_meters cascade;
create table port_depth_meters (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_depth_meters (name,detail) values
    ('A', '23.2+ meters'),
    ('B', '21.6–22.9 meters'),
    ('C', '20.1–21.3 meters'),
    ('D', '18.6–19.8 meters'),
    ('E', '17.1–18.2 meters'),
    ('F', '15.5–16.8 meters'),
    ('G', '14.0–15.2 meters'),
    ('H', '12.5–13.7 meters'),
    ('J', '11.0–12.2 meters'),
    ('K', '9.4–10.7 meters'),
    ('L', '7.9–9.1 meters'),
    ('M', '6.4–7.6 meters'),
    ('N', '4.9–6.1 meters'),
    ('O', '3.4–4.6 meters'),
    ('P', '1.8–3.0 meters'),
    ('Q', '0–1.5 meters');
