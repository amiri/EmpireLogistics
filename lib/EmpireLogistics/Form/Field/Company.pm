package EmpireLogistics::Form::Field::Company;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated Companies' }
sub build_id { 'companies' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Associated Companies' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
