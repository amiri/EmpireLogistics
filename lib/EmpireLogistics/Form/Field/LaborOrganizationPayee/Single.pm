package EmpireLogistics::Form::Field::LaborOrganizationPayee::Single;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2::Single';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Payee' }
sub build_id { 'labor-organization-payee-single' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Payee' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;


