package EmpireLogistics::Schema::Result::Warehouse;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("warehouse");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "warehouse_id_seq",
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
  "name",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "status",
  {
    data_type => "enum",
    extra => { custom_type_name => "warehouse_status", list => ["open", "closed"] },
    is_nullable => 1,
  },
  "area",
  { data_type => "integer", is_nullable => 1 },
  "owner",
  {
    data_type => "integer",
    is_nullable => 0,
  },
  "date_opened",
  { data_type => "date", is_nullable => 1 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "geometry",
  { data_type => "geometry", is_nullable => 1, size => "12544,3519" },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("warehouse_name_lat_lon", ["name", "latitude", "longitude"]);
__PACKAGE__->has_many(
  "company_warehouses",
  "EmpireLogistics::Schema::Result::CompanyWarehouse",
  { "foreign.warehouse" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_warehouses",
  "EmpireLogistics::Schema::Result::LaborOrganizationWarehouse",
  { "foreign.warehouse" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "warehouse_addresses",
  "EmpireLogistics::Schema::Result::WarehouseAddress",
  { "foreign.warehouse" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "warehouse_medias",
  "EmpireLogistics::Schema::Result::WarehouseMedia",
  { "foreign.warehouse" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_walmarts",
  "EmpireLogistics::Schema::Result::WarehouseWalmart",
  { "foreign.warehouse" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "warehouse_work_stoppages",
  "EmpireLogistics::Schema::Result::WarehouseWorkStoppage",
  { "foreign.warehouse" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

__PACKAGE__->many_to_many(
    'addresses' => 'warehouse_addresses', 'address'
);
__PACKAGE__->many_to_many(
    'companies' => 'company_warehouses', 'company'
);
__PACKAGE__->many_to_many(
    'labor_organizations' => 'labor_organization_warehouses', 'labor_organization'
);
__PACKAGE__->many_to_many(
    'work_stoppages' => 'warehouse_work_stoppages', 'work_stoppage'
);
__PACKAGE__->many_to_many("medias", "warehouse_medias", "media");
__PACKAGE__->belongs_to(
    "owner",
    "EmpireLogistics::Schema::Result::WarehouseOwner",
    {"foreign.id" => "self.owner" },
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
