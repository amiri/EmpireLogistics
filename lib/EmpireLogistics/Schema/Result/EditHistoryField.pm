use utf8;
package EmpireLogistics::Schema::Result::EditHistoryField;

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
__PACKAGE__->table("edit_history_field");
__PACKAGE__->add_columns(
  "edit_history",
  { data_type => "integer", is_nullable => 0 },
  "field",
  { data_type => "text", is_nullable => 0 },
  "original_value",
  { data_type => "text", is_nullable => 1 },
  "new_value",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("edit_history", "field");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-03 01:14:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Wn9tIkxYnVPJr+MB2BvskA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
