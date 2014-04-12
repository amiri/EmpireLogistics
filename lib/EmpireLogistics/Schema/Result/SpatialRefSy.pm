package EmpireLogistics::Schema::Result::SpatialRefSy;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("spatial_ref_sys");
__PACKAGE__->add_columns(
  "srid",
  { data_type => "integer", is_nullable => 0 },
  "auth_name",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "auth_srid",
  { data_type => "integer", is_nullable => 1 },
  "srtext",
  { data_type => "varchar", is_nullable => 1, size => 2048 },
  "proj4text",
  { data_type => "varchar", is_nullable => 1, size => 2048 },
);
__PACKAGE__->set_primary_key("srid");


__PACKAGE__->meta->make_immutable;
1;
