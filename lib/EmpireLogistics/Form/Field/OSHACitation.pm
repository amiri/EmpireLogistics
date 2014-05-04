package EmpireLogistics::Form::Field::OSHACitation;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'OSHA Citations' }
sub build_id { 'osha-citations' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Company OSHA Citations' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

