package EmpireLogistics::Form::Field::RailNode;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated Rail Intersections' }
sub build_id { 'rail-nodes' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Associated Rail Intersections' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;


