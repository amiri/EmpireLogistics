package EmpireLogistics::Schema::Result::Address;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("address");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "address_id_seq",
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
  "street_address",
  { data_type => "text", is_nullable => 1 },
  "city",
  { data_type => "text", is_nullable => 1 },
  "state",
  { data_type => "text", is_nullable => 1 },
  "postal_code",
  { data_type => "text", is_nullable => 1 },
  "country",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "company_addresses",
  "EmpireLogistics::Schema::Result::CompanyAddress",
  { "foreign.address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_addresses",
  "EmpireLogistics::Schema::Result::LaborOrganizationAddress",
  { "foreign.address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_payee_addresses",
  "EmpireLogistics::Schema::Result::LaborOrganizationPayeeAddress",
  { "foreign.address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "port_addresses",
  "EmpireLogistics::Schema::Result::PortAddress",
  { "foreign.address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_addresses",
  "EmpireLogistics::Schema::Result::WarehouseAddress",
  { "foreign.address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);




__PACKAGE__->meta->make_immutable;
1;
