package EmpireLogistics::Schema::Result::Address;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("address");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "address_id_seq",
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
  "street_address",
  { data_type => "text", is_nullable => 0 },
  "city",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "state",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "postal_code",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "country",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "company_addresses",
  "EmpireLogistics::Schema::Result::CompanyAddress",
  { "foreign.address" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_addresses",
  "EmpireLogistics::Schema::Result::LaborOrganizationAddress",
  { "foreign.address" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_payee_addresses",
  "EmpireLogistics::Schema::Result::LaborOrganizationPayeeAddress",
  { "foreign.address" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "port_addresses",
  "EmpireLogistics::Schema::Result::PortAddress",
  { "foreign.address" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "rail_node_addresses",
  "EmpireLogistics::Schema::Result::RailNodeAddress",
  { "foreign.address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_addresses",
  "EmpireLogistics::Schema::Result::WarehouseAddress",
  { "foreign.address" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

__PACKAGE__->many_to_many(
    'companies' => 'company_addresses' => 'company',
);
__PACKAGE__->many_to_many(
    'labor_organizations' => 'labor_organization_addresses' => 'labor_organization',
);
__PACKAGE__->many_to_many(
    'labor_organization_payees' => 'labor_organization_payee_addresses' => 'labor_organization_payee',
);
__PACKAGE__->many_to_many(
    'ports' => 'port_addresses' => 'port',
);
__PACKAGE__->many_to_many(
    'warehouses' => 'warehouse_addresses' => 'warehouse',
);

__PACKAGE__->belongs_to(
  "city",
  "EmpireLogistics::Schema::Result::City",
  { id => "city" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
	where => { "me.delete_time" => undef },
  },
);
__PACKAGE__->belongs_to(
  "state",
  "EmpireLogistics::Schema::Result::State",
  { id => "state" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
	where => { "me.delete_time" => undef },
  },
);
__PACKAGE__->belongs_to(
  "postal_code",
  "EmpireLogistics::Schema::Result::PostalCode",
  { id => "postal_code" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
	where => { "me.delete_time" => undef },
  },
);
__PACKAGE__->belongs_to(
  "country",
  "EmpireLogistics::Schema::Result::Country",
  { id => "country" },
  {
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
	where => { "me.delete_time" => undef },
  },
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
