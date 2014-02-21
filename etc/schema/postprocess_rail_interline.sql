update raw_rail_interline set iidq = null where iidq = '';
update raw_rail_interline set impedance = null where impedance = '';

insert into rail_interline (
    interline_id_number,
    forwarding_node,
    receiving_node,
    forwarding_node_owner,
    receiving_node_owner,
    junction_code,
    impedance,
    geometry
) select
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
