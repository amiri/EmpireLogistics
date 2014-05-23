package EmpireLogistics::Schema::Result::Timezone;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("timezone");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "timezone_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "gmt_offset",
  { data_type => "numeric", is_nullable => 1, size => [3, 1] },
  "dst_offset",
  { data_type => "numeric", is_nullable => 1, size => [3, 1] },
  "raw_offset",
  { data_type => "numeric", is_nullable => 1, size => [3, 1] },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("unique_timezone_name", ["name"]);
__PACKAGE__->has_many(
  "cities",
  "EmpireLogistics::Schema::Result::City",
  { "foreign.timezone" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "states",
  "EmpireLogistics::Schema::Result::State",
  { "foreign.timezone" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->belongs_to(
    "object_type" => "EmpireLogistics::Schema::Result::ObjectType",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.name " =>
                    {-ident => "$args->{self_resultsource}.name"},
            },
            $args->{self_rowobj}
                && {
                "$args->{foreign_alias}.name" =>
                    $args->{self_resultsource}->name,
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
                "$args->{foreign_alias}.object" =>
                    {-ident => "$args->{self_alias}.id"},
                "$args->{foreign_alias}.object_type" =>
                    $args->{self_rowobj}->object_type->id,
            },
            $args->{self_rowobj}
                && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" =>
                    $args->{self_rowobj}->object_type->id,
                },
        );
    },
    {order_by => {-desc => "create_time"}},
);

__PACKAGE__->meta->make_immutable;
1;
