use utf8;
package EmpireLogistics::Schema::Result::RailSignal;

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
__PACKAGE__->table("rail_signal");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "rail_signal_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.021239+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.021239+00",
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


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aPChiAKtCjrcFxGykBcHsQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
