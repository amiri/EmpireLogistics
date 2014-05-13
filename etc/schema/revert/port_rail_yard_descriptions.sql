-- Revert port_rail_yard_descriptions

BEGIN;

alter table port drop column description;
alter table rail_node drop column description;
alter table rail_line drop column description;

COMMIT;
