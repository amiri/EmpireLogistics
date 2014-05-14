package EmpireLogistics::Form::Field::WorkStoppage;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated Labor Actions' }
sub build_id { 'work-stoppages' }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

