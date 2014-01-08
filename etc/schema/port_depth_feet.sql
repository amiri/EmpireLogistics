drop table if exists port_depth_feet cascade;
create table port_depth_feet (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into port_depth_feet (name,detail) values
    ('A', '76+ feet'),
    ('B', '71–75 feet'),
    ('C', '66–70 feet'),
    ('D', '61–65 feet'),
    ('E', '56–60 feet'),
    ('F', '51–55 feet'),
    ('G', '46–50 feet'),
    ('H', '41–45 feet'),
    ('J', '36–40 feet'),
    ('K', '31–35 feet'),
    ('L', '26–30 feet'),
    ('M', '21–25 feet'),
    ('N', '16–20 feet'),
    ('O', '11–15 feet'),
    ('P', '6–10 feet'),
    ('Q', '0–5 feet');
