package EmpireLogistics::Form::Field::LaborOrganization;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated Labor Organizations' }
sub build_id { 'labor-organizations' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Associated Labor Organizations' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
