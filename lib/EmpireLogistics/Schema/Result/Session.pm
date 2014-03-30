package EmpireLogistics::Schema::Result::Session;

use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("session");
__PACKAGE__->add_columns(
  "id",
  { data_type => "varchar", is_nullable => 0, size => 72 },
  "session_data",
  { data_type => "text", is_nullable => 0 },
  "expires",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


__PACKAGE__->meta->make_immutable;
1;
