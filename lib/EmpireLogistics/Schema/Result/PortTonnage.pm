use utf8;
package EmpireLogistics::Schema::Result::PortTonnage;

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
__PACKAGE__->table("port_tonnage");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "port_tonnage_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.170675+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-22 19:27:40.170675+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "port",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "year",
  { data_type => "integer", is_nullable => 0 },
  "domestic_tonnage",
  { data_type => "integer", is_nullable => 1 },
  "foreign_tonnage",
  { data_type => "integer", is_nullable => 1 },
  "import_tonnage",
  { data_type => "integer", is_nullable => 1 },
  "export_tonnage",
  { data_type => "integer", is_nullable => 1 },
  "total_tonnage",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("port_tonnage_port_year_key", ["port", "year"]);
__PACKAGE__->belongs_to(
  "port",
  "EmpireLogistics::Schema::Result::Port",
  { id => "port" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-22 19:28:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m9EjuhpscvdLiqdQSauJWQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
