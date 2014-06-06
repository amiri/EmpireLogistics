package EmpireLogistics::Schema::Result::RailNodeMedia;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("rail_node_media");
__PACKAGE__->add_columns(
  "rail_node",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "media",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("rail_node", "media");
__PACKAGE__->belongs_to(
  "media",
  "EmpireLogistics::Schema::Result::Media",
  { id => "media" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "rail_node",
  "EmpireLogistics::Schema::Result::RailNode",
  { id => "rail_node" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

__PACKAGE__->meta->make_immutable;
1;
