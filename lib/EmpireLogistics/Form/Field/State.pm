package EmpireLogistics::Form::Field::State;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

has '+multiple' => (default => 0);
sub build_label { 'State' }
sub build_id { '' }
sub build_element_class {['state-select2']}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
