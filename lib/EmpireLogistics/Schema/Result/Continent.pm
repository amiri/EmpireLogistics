package EmpireLogistics::Schema::Result::Continent;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("continent");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "continent_id_seq",
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
  "code",
  { data_type => "varchar", is_nullable => 0, size => 2 },
  "geonameid",
  { data_type => "integer", is_nullable => 0 },
  "alternate_names",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("unique_continent_code", ["code"]);
__PACKAGE__->add_unique_constraint("unique_continent_name", ["name"]);
__PACKAGE__->has_many(
  "countries",
  "EmpireLogistics::Schema::Result::Country",
  { "foreign.continent" => "self.id" },
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
