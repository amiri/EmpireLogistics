package EmpireLogistics::Form::Field::LaborOrganizationPayee;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated Payees' }
sub build_id { 'labor-organization-payees' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Payees' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

