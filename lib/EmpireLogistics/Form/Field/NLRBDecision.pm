package EmpireLogistics::Form::Field::NLRBDecision;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'NLRB Decisions' }
sub build_id { 'nlrb-decisions' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Company NLRB Decisions' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

