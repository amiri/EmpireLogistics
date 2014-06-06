package EmpireLogistics::Schema::Result::Media;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("media");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_id_seq",
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
  "url",
  { data_type => "text", is_nullable => 0 },
  "mime_type",
  { data_type => "text", is_nullable => 0 },
  "width",
  { data_type => "integer", is_nullable => 0 },
  "height",
  { data_type => "integer", is_nullable => 0 },
  "caption",
  { data_type => "text", is_nullable => 1 },
  "alt",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "port_medias",
  "EmpireLogistics::Schema::Result::PortMedia",
  { "foreign.media" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "rail_node_medias",
  "EmpireLogistics::Schema::Result::RailNodeMedia",
  { "foreign.media" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_medias",
  "EmpireLogistics::Schema::Result::WarehouseMedia",
  { "foreign.media" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->many_to_many("ports", "port_medias", "port");
__PACKAGE__->many_to_many("rail_nodes", "rail_node_medias", "rail_node");
__PACKAGE__->many_to_many("warehouses", "warehouse_medias", "warehouse");



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
