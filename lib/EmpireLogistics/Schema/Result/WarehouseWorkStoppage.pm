package EmpireLogistics::Schema::Result::WarehouseWorkStoppage;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("warehouse_work_stoppage");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "warehouse_work_stoppage_id_seq",
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
  "warehouse",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "work_stoppage",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "warehouse_work_stoppage_warehouse_work_stoppage_key",
  ["warehouse", "work_stoppage"],
);
__PACKAGE__->belongs_to(
  "warehouse",
  "EmpireLogistics::Schema::Result::Warehouse",
  { id => "warehouse" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "work_stoppage",
  "EmpireLogistics::Schema::Result::WorkStoppage",
  { id => "work_stoppage" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);




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
