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
  "work_stoppage_type",
  {
    data_type => "integer",
    is_nullable => 0,
  },
  "name",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("work_stoppage_unique_name", ["name"]);

__PACKAGE__->belongs_to(
    "work_stoppage_type" => "EmpireLogistics::Schema::Result::WorkStoppageType",
    {"foreign.id" => "self.work_stoppage_type"},
    {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

__PACKAGE__->has_many(
  "labor_organization_work_stoppages",
  "EmpireLogistics::Schema::Result::LaborOrganizationWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "port_work_stoppages",
  "EmpireLogistics::Schema::Result::PortWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "rail_line_work_stoppages",
  "EmpireLogistics::Schema::Result::RailLineWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "rail_node_work_stoppages",
  "EmpireLogistics::Schema::Result::RailNodeWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "warehouse_work_stoppages",
  "EmpireLogistics::Schema::Result::WarehouseWorkStoppage",
  { "foreign.work_stoppage" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

__PACKAGE__->many_to_many(
    labor_organizations => "labor_organization_work_stoppages", "labor_organization"
);
__PACKAGE__->many_to_many(
    ports => "port_work_stoppages", "port"
);
__PACKAGE__->many_to_many(
    rail_lines => "rail_line_work_stoppages", "rail_line"
);
__PACKAGE__->many_to_many(
    rail_nodes => "rail_node_work_stoppages", "rail_node"
);
__PACKAGE__->many_to_many(
    warehouses => "warehouse_work_stoppages", "warehouse"
);


__PACKAGE__->belongs_to(
    "object_type" =>
    "EmpireLogistics::Schema::Result::ObjectType",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.name " => { -ident => "$args->{self_resultsource}.name" },
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.name" => $args->{self_resultsource}->name,
            },
        );
    },
);

__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

__PACKAGE__->meta->make_immutable;
1;
