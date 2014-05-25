package EmpireLogistics::Schema::Result::State;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("state");
__PACKAGE__->add_columns(
    "id", {
        data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
        sequence          => "state_id_seq",
    },
    "create_time", {
        data_type     => "timestamp with time zone",
        default_value => \'now()',
        is_nullable   => 0,
    },
    "update_time", {
        data_type     => "timestamp with time zone",
        default_value => \'now()',
        is_nullable   => 0,
    },
    "delete_time",
    {data_type => "timestamp with time zone", is_nullable => 1},
    "name",
    {data_type => "text", is_nullable => 0},
    "name_ascii",
    {data_type => "text", is_nullable => 0},
    "geonameid",
    {data_type => "integer", is_nullable => 0},
    "alternate_names",
    {data_type => "text", is_nullable => 1},
    "abbreviation",
    {data_type => "varchar", is_nullable => 1, size => 20},
    "country",
    {data_type => "integer", is_foreign_key => 1, is_nullable => 0},
    "population",
    {data_type => "integer", is_nullable => 1},
    "timezone",
    {data_type => "integer", is_foreign_key => 1, is_nullable => 0},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("unique_state_country_name", ["name", "country"]);

__PACKAGE__->has_many(
    "rail_subdivision_states",
    "EmpireLogistics::Schema::Result::RailSubdivisionState",
    {"foreign.state" => "self.id"},
    {
        where => {"me.delete_time" => undef},
        cascade_copy => 0, cascade_delete => 0
    },
);
__PACKAGE__->has_many(
  "cities",
  "EmpireLogistics::Schema::Result::City",
  { "foreign.state" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "country",
  "EmpireLogistics::Schema::Result::Country",
  { id => "country" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "postal_codes",
  "EmpireLogistics::Schema::Result::PostalCode",
  { "foreign.state" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
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
