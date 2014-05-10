package EmpireLogistics::Schema::Result::RailLine;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("rail_line");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_line_id_seq",
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
  "link_id",
  { data_type => "text", is_nullable => 1 },
  "route_id",
  { data_type => "text", is_nullable => 1 },
  "miles",
  { data_type => "double precision", is_nullable => 1 },
  "direction",
  { data_type => "text", is_nullable => 1 },
  "track_type",
  { data_type => "text", is_nullable => 1 },
  "grade",
  { data_type => "text", is_nullable => 1 },
  "gauge",
  { data_type => "text", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
  "passenger",
  { data_type => "text", is_nullable => 1 },
  "military_subsystem",
  { data_type => "text", is_nullable => 1 },
  "signal_system",
  { data_type => "text", is_nullable => 1 },
  "traffic_density",
  { data_type => "text", is_nullable => 1 },
  "line_class",
  { data_type => "text", is_nullable => 1 },
  "a_junction",
  { data_type => "text", is_nullable => 1 },
  "b_junction",
  { data_type => "text", is_nullable => 1 },
  "subdivision",
  { data_type => "text", is_nullable => 1 },
  "owner1",
  { data_type => "text", is_nullable => 1 },
  "owner2",
  { data_type => "text", is_nullable => 1 },
  "trackage_rights1",
  { data_type => "text", is_nullable => 1 },
  "trackage_rights2",
  { data_type => "text", is_nullable => 1 },
  "trackage_rights3",
  { data_type => "text", is_nullable => 1 },
  "geometry",
  { data_type => "geometry", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "rail_line_work_stoppages",
  "EmpireLogistics::Schema::Result::RailLineWorkStoppage",
  { "foreign.rail_line" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

__PACKAGE__->many_to_many(
    'work_stoppages' => 'rail_line_work_stoppages', 'work_stoppage'
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

sub name {
    my $self = shift;
    return $self->route_id;
}

__PACKAGE__->meta->make_immutable;
1;
