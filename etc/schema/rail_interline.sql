update raw_rail_interline set iidq = null where iidq = '';
update raw_rail_interline set impedance = null where impedance = '';

drop table if exists rail_interline cascade;
create table rail_interline (
    id integer not null primary key,
    interline_id_number integer,
    forwarding_node text,
    receiving_node text,
    forwarding_node_owner text, 
    receiving_node_owner text,
    junction_code text,
    impedance integer,
    description text,
    geometry geometry
);
insert into rail_interline (
    id,
    interline_id_number,
    forwarding_node,
    receiving_node,
    forwarding_node_owner,
    receiving_node_owner,
    junction_code,
    impedance,
    geometry
) select
    ri.ogc_fid,
    ri.iidq::integer,
    rna.name,
    rnb.name,
    roa.name,
    rob.name,
    ri.iidname,
    ri.impedance::integer,
    ri.wkb_geometry
from raw_rail_interline ri
    left join rail_node rna
        on ri.ija::integer = rna.junction_id
    left join rail_node rnb
        on ri.ijb::integer = rnb.junction_id
    left join rail_ownership roa
        on ri.wa = roa.reporting_mark
    left join rail_ownership rob
        on ri.wb = rob.reporting_mark
;
