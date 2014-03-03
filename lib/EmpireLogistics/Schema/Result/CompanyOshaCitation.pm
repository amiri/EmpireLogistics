use utf8;
package EmpireLogistics::Schema::Result::CompanyOshaCitation;

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
__PACKAGE__->table("company_osha_citation");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "company_osha_citation_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.572389+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-02-27 14:49:06.572389+00",
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "company",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "osha_citation",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "company_osha_citation_company_osha_citation_key",
  ["company", "osha_citation"],
);
__PACKAGE__->belongs_to(
  "company",
  "EmpireLogistics::Schema::Result::Company",
  { id => "company" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "osha_citation",
  "EmpireLogistics::Schema::Result::OshaCitation",
  { id => "osha_citation" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-03 01:14:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8y1sqkUT92OXYN4g+KDUEA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
