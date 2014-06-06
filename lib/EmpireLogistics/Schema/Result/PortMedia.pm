package EmpireLogistics::Schema::Result::PortMedia;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("port_media");
__PACKAGE__->add_columns(
  "port",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "media",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("port", "media");
__PACKAGE__->belongs_to(
  "media",
  "EmpireLogistics::Schema::Result::Media",
  { id => "media" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "port",
  "EmpireLogistics::Schema::Result::Port",
  { id => "port" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


__PACKAGE__->meta->make_immutable;

1;
