package EmpireLogistics::Form::Field::Warehouse;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated Warehouses' }
sub build_id { 'warehouses' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Associated Warehouses' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;



