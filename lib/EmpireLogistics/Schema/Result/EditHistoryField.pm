package EmpireLogistics::Schema::Result::EditHistoryField;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("edit_history_field");
__PACKAGE__->add_columns(
  "edit_history",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "field",
  { data_type => "text", is_nullable => 0 },
  "original_value",
  { data_type => "text", is_nullable => 1 },
  "new_value",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("edit_history", "field");
__PACKAGE__->belongs_to(
  "edit_history",
  "EmpireLogistics::Schema::Result::EditHistory",
  { id => "edit_history" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);




__PACKAGE__->meta->make_immutable;
1;
