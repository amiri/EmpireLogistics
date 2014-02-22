update raw_rail_node set jturn = null where jturn in ('-','_');
update raw_rail_node set astate = null where astate in ('-','_');
update raw_rail_node set splc = null where splc in ('-','_');
update raw_rail_node set jname = 'Unknown' where jname in ('-','_');

insert into rail_node (
    id,
    junction_id,
    name,
    incident_links,
    latitude,
    longitude,
    geometry
) select
    rn.gid as id,
    rn.jid as junction_id,
    rn.jname as name,
    rn.incid as incident_links,
    ST_Y(ST_Transform(rn.geom,4326)) as latitude,
    ST_X(ST_Transform(rn.geom,4326)) as longitude,
    rn.geom as geometry
from raw_rail_node rn
;
