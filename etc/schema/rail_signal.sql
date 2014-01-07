drop table if exists rail_signal cascade;
create table rail_signal (
    id serial primary key not null,
    name text not null,
    detail text not null
);
insert into rail_signal (name,detail) values
    ('S', 'Automatic Control System'),
    ('T', 'Automatic Train Control'),
    ('U', 'Automatic Train Stop'),
    ('I', 'Itc (Amtk Incremental Train Control)'),
    ('C', 'Centralized Traffic Control'),
    ('B', 'Automatic Block Signals'),
    ('M', 'Manual'),
    ('O', 'Timetable And Train Order');
