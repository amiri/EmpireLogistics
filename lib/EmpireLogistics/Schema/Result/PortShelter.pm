package EmpireLogistics::Schema::Result::PortShelter;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("port_shelter");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "port_shelter_id_seq",
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
  { data_type => "text", is_nullable => 0 },
  "detail",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");




__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::EditHistory",
    sub {
        my $args = shift;
        return +{
            "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
            "$args->{foreign_alias}.object_type" => $args->{self_alias},
        }
    },
);

__PACKAGE__->meta->make_immutable;
1;
