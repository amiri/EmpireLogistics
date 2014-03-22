use utf8;
package EmpireLogistics::Schema::Result::RailLineWorkStoppage;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "TimeStamp",
  "InflateColumn::DateTime::Duration",
);
__PACKAGE__->table("rail_line_work_stoppage");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_line_work_stoppage_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.730778+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.730778+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "rail_line",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "work_stoppage",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "rail_line_work_stoppage_rail_line_work_stoppage_key",
  ["rail_line", "work_stoppage"],
);
__PACKAGE__->belongs_to(
  "rail_line",
  "EmpireLogistics::Schema::Result::RailLine",
  { id => "rail_line" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "work_stoppage",
  "EmpireLogistics::Schema::Result::WorkStoppage",
  { id => "work_stoppage" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aTSRrC6IDsqacReQiRpfjQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
