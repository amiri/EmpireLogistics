package EmpireLogistics::Form::Field::Port;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated Ports' }
sub build_id { 'ports' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Associated Ports' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

