package EmpireLogistics::Schema::Result::Company;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("company");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "company_id_seq",
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
  "company_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "company_type",
      list => ["3PL", "commercial", "financial", "industrial"],
    },
    is_nullable => 1,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "company_addresses",
  "EmpireLogistics::Schema::Result::CompanyAddress",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_nlrb_decisions",
  "EmpireLogistics::Schema::Result::CompanyNlrbDecision",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_osha_citations",
  "EmpireLogistics::Schema::Result::CompanyOshaCitation",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_ports",
  "EmpireLogistics::Schema::Result::CompanyPort",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_rail_nodes",
  "EmpireLogistics::Schema::Result::CompanyRailNode",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_warehouses",
  "EmpireLogistics::Schema::Result::CompanyWarehouse",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many(
    'addresses' => 'company_addresses', 'address'
);
__PACKAGE__->many_to_many(
    'ports' => 'company_ports', 'port'
);
__PACKAGE__->many_to_many(
    'rail_nodes' => 'company_rail_nodes', 'rail_node'
);
__PACKAGE__->many_to_many(
    'warehouses' => 'company_warehouses', 'warehouse'
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
