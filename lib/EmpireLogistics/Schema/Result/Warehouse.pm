use utf8;
package EmpireLogistics::Schema::Result::Warehouse;

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
__PACKAGE__->table("warehouse");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "warehouse_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.375807+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.375807+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "status",
  {
    data_type => "enum",
    extra => { custom_type_name => "warehouse_status", list => ["open", "closed"] },
    is_nullable => 1,
  },
  "area",
  { data_type => "integer", is_nullable => 1 },
  "owner",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "warehouse_owner",
      list => [
        "walmart",
        "target",
        "costco",
        "krogers",
        "walgreens",
        "home depot",
        "amazon",
        "ikea",
      ],
    },
    is_nullable => 1,
  },
  "date_opened",
  { data_type => "date", is_nullable => 1 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "geometry",
  { data_type => "geometry", is_nullable => 1, size => "12544,3519" },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "company_warehouses",
  "EmpireLogistics::Schema::Result::CompanyWarehouse",
  { "foreign.warehouse" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "labor_organization_warehouses",
  "EmpireLogistics::Schema::Result::LaborOrganizationWarehouse",
  { "foreign.warehouse" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_addresses",
  "EmpireLogistics::Schema::Result::WarehouseAddress",
  { "foreign.warehouse" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_work_stoppages",
  "EmpireLogistics::Schema::Result::WarehouseWorkStoppage",
  { "foreign.warehouse" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-03 01:14:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Xex3vrusxGhFmIhLsybspg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
