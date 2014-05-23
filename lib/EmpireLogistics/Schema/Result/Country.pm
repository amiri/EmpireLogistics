package EmpireLogistics::Schema::Result::Country;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("country");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "country_id_seq",
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
  "official_name",
  { data_type => "text", is_nullable => 1 },
  "official_name_ascii",
  { data_type => "text", is_nullable => 1 },
  "iso_alpha2",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "iso_alpha3",
  { data_type => "varchar", is_nullable => 1, size => 3 },
  "iso_id",
  { data_type => "integer", is_nullable => 0 },
  "fips_code",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "area_kilometers",
  { data_type => "integer", is_nullable => 1 },
  "population",
  { data_type => "integer", is_nullable => 1 },
  "continent",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tld",
  { data_type => "text", is_nullable => 1 },
  "currency",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "postal",
  { data_type => "text", is_nullable => 1 },
  "postalregex",
  { data_type => "text", is_nullable => 1 },
  "languages",
  { data_type => "text", is_nullable => 1 },
  "geonameid",
  { data_type => "integer", is_nullable => 0 },
  "neighbours",
  { data_type => "text", is_nullable => 1 },
  "alternate_names",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("unique_country_geonameid", ["geonameid"]);
__PACKAGE__->add_unique_constraint("unique_country_iso_alpha2", ["iso_alpha2"]);
__PACKAGE__->add_unique_constraint("unique_country_iso_alpha3", ["iso_alpha3"]);
__PACKAGE__->add_unique_constraint("unique_country_iso_id", ["iso_id"]);
__PACKAGE__->add_unique_constraint("unique_country_name", ["name"]);
__PACKAGE__->add_unique_constraint("unique_country_name_tld", ["name", "tld"]);
__PACKAGE__->add_unique_constraint("unique_country_official_name", ["official_name"]);
__PACKAGE__->add_unique_constraint("unique_country_official_name_ascii", ["official_name_ascii"]);
__PACKAGE__->has_many(
  "cities",
  "EmpireLogistics::Schema::Result::City",
  { "foreign.country" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "continent",
  "EmpireLogistics::Schema::Result::Continent",
  { id => "continent" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "currency",
  "EmpireLogistics::Schema::Result::Currency",
  { id => "currency" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
  },
);
__PACKAGE__->has_many(
  "postal_codes",
  "EmpireLogistics::Schema::Result::PostalCode",
  { "foreign.country" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "states",
  "EmpireLogistics::Schema::Result::State",
  { "foreign.country" => "self.id" },
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
