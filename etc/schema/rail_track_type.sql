drop table if exists rail_track_type cascade;
create table rail_track_type (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_track_type (name,detail) values
    ('A', 'Main'),
    ('S', 'Siding'),
    ('P', 'Spur'),
    ('F', 'Car Ferry'),
    ('Y', 'Yard Track'),
    ('B', 'Main Through Yard'),
	('R', 'Transfer Tracks'),
	('T', 'Station Tracks'),
	('Z', 'Notional Connector');

