package EmpireLogistics::Schema::Result::Company;



use Moose;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("company");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "company_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.136724+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.136724+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "company_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "company_type",
      list => ["3PL", "commercial", "financial", "industrial"],
    },
    is_nullable => 1,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "company_addresses",
  "EmpireLogistics::Schema::Result::CompanyAddress",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_nlrb_decisions",
  "EmpireLogistics::Schema::Result::CompanyNlrbDecision",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_osha_citations",
  "EmpireLogistics::Schema::Result::CompanyOshaCitation",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_ports",
  "EmpireLogistics::Schema::Result::CompanyPort",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_rail_nodes",
  "EmpireLogistics::Schema::Result::CompanyRailNode",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "company_warehouses",
  "EmpireLogistics::Schema::Result::CompanyWarehouse",
  { "foreign.company" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);




__PACKAGE__->meta->make_immutable;
1;
