package EmpireLogistics::Form::Field::RailLine;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::BaseSelect2';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Associated RailLines' }
sub build_id { 'rail-lines' }

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;



