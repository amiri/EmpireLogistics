package EmpireLogistics::Form::Field::WorkStoppage;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Labor Actions' }
sub build_id { 'work-stoppages' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Labor Actions' } }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

