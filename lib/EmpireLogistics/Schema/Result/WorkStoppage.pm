package EmpireLogistics::Schema::Result::WorkStoppage;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("work_stoppage");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "work_stoppage_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "start_date",
  { data_type => "date", is_nullable => 0 },
  "end_date",
  { data_type => "date", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "labor_organization_work_stoppages",
  "EmpireLogistics::Schema::Result::LaborOrganizationWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "port_work_stoppages",
  "EmpireLogistics::Schema::Result::PortWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "rail_line_work_stoppages",
  "EmpireLogistics::Schema::Result::RailLineWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "rail_node_work_stoppages",
  "EmpireLogistics::Schema::Result::RailNodeWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_work_stoppages",
  "EmpireLogistics::Schema::Result::WarehouseWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);




__PACKAGE__->meta->make_immutable;
1;
