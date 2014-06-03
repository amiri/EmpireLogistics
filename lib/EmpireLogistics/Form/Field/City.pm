package EmpireLogistics::Form::Field::City;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2::Single';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'City' }
sub build_id { '' }
sub build_element_class {['city-select2']}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
