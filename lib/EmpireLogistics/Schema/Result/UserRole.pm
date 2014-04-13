package EmpireLogistics::Schema::Result::UserRole;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("user_role");
__PACKAGE__->add_columns(
  "user",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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
);
__PACKAGE__->set_primary_key("user", "role");
__PACKAGE__->belongs_to(
  "role",
  "EmpireLogistics::Schema::Result::Role",
  { id => "role" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "user",
  "EmpireLogistics::Schema::Result::User",
  { id => "user" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_resultsource}->name,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_resultsource}->name,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

__PACKAGE__->meta->make_immutable;
1;
