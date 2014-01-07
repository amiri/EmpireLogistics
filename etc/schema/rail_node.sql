update raw_rail_node set jturn = null where jturn in ('-','_');
update raw_rail_node set astate = null where astate in ('-','_');
update raw_rail_node set splc = null where splc in ('-','_');
update raw_rail_node set jname = 'Unknown' where jname in ('-','_');

drop table if exists rail_node cascade;
create table rail_node (
    id integer not null primary key,
    junction_id integer,
    name text,
    incident_links integer,
    description text,
    geometry geometry
);
insert into rail_node (
    id,
    junction_id,
    name,
    incident_links,
    geometry
) select
    rn.gid as id,
    rn.jid as junction_id,
    rn.jname as name,
    rn.incid as incident_links,
    rn.geom as geometry
from raw_rail_node rn
;

