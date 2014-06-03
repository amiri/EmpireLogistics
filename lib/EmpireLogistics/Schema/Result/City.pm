package EmpireLogistics::Schema::Result::City;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("city");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "city_id_seq",
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
  "name_ascii",
  { data_type => "text", is_nullable => 1 },
  "geonameid",
  { data_type => "integer", is_nullable => 0 },
  "alternate_names",
  { data_type => "text", is_nullable => 1 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "country",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "admin1",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "admin2",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "admin3",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "admin4",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "fcode",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "state",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "population",
  { data_type => "integer", is_nullable => 1 },
  "timezone",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "geometry",
  { data_type => "geometry", is_nullable => 1, size => "12544,3519" },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "addresses",
  "EmpireLogistics::Schema::Result::Address",
  { "foreign.city" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "country",
  "EmpireLogistics::Schema::Result::Country",
  { id => "country" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
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
  },
);
__PACKAGE__->belongs_to(
  "timezone",
  "EmpireLogistics::Schema::Result::Timezone",
  { id => "timezone" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
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
