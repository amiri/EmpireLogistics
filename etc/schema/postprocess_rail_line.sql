update raw_rail_line set trktyp = null where trktyp in ('-','_');
update raw_rail_line set grade = null where grade in ('-','_');
update raw_rail_line set gauge = 'S' where gauge in ('-','_');
update raw_rail_line set status = null where status in ('-','_');
update raw_rail_line set pasngr = null where pasngr in ('-','_');
update raw_rail_line set milit = null where milit in ('-','_');
update raw_rail_line set signal = null where signal in ('-','_');
update raw_rail_line set densty = null where densty in ('-','_');
update raw_rail_line set mlc = null where mlc in ('-','_');
update raw_rail_line set sb = null where sb in ('-','_');
update raw_rail_line set w1 = null where w1 in ('-','_');
update raw_rail_line set w2 = null where w2 in ('-','_');
update raw_rail_line set t1 = null where t1 in ('-','_');
update raw_rail_line set t2 = null where t2 in ('-','_');
update raw_rail_line set t3 = null where t3 in ('-','_');

insert into rail_line (
    id,
    link_id,
    route_id,
    miles,
    direction,
    track_type,
    grade,
    gauge,
    status,
    passenger,
    military_subsystem,
    signal_system,
    traffic_density,
    line_class,
    a_junction,
    b_junction,
    subdivision,
    owner1,
    owner2,
    trackage_rights1,
    trackage_rights2,
    trackage_rights3,
    geometry
) select
    rl.gid as id,
    rl.alid as link_id,
    rl.rtid as route_id,
    rl.miles as miles,
    rl.dirctn as direction,
    tt.detail as track_type,
    tgd.detail as grade,
    tg.detail as gauge,
    ts.detail as status,
    ps.detail as passenger,
    mil.detail as military_subsystem,
    sig.detail as signal_system,
    dns.detail as traffic_density,
    lc.detail as line_class,
    rn1.jname as a_junction,
    rn2.jname as b_junction,
    rs.full_name as subdivision,
    ro1.name as owner1,
    ro2.name as owner2,
    tr1.name as trackage_rights1,
    tr2.name as trackage_rights2,
    tr3.name as trackage_rights3,
    rl.geom as geometry
from raw_rail_line rl
    left join rail_track_type tt
		on rl.trktyp = tt.name
    left join rail_track_grade tgd
		on rl.grade = tgd.name
    left join rail_track_gauge tg
		on rl.gauge = tg.name
    left join rail_status ts
		on rl.status = ts.name
    left join rail_passenger ps
		on rl.pasngr = ps.name
    left join rail_military mil
		on rl.milit = mil.name
    left join rail_signal sig
		on rl.signal = sig.name
    left join rail_density dns
		on rl.densty::integer = dns.name
    left join rail_line_class lc
		on rl.mlc = lc.name
    left join raw_rail_node rn1
		on rl.ja = rn1.jid
    left join raw_rail_node rn2
		on rl.jb = rn2.jid
    left join rail_subdivision rs
		on rl.sb = rs.name
    left join rail_ownership ro1
		on rl.w1 = ro1.reporting_mark
    left join rail_ownership ro2
		on rl.w2 = ro2.reporting_mark
    left join rail_ownership tr1
		on rl.t1 = tr1.reporting_mark
    left join rail_ownership tr2
		on rl.t2 = tr2.reporting_mark
    left join rail_ownership tr3
		on rl.t3 = tr3.reporting_mark
;
