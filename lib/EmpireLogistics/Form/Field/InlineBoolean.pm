package EmpireLogistics::Form::Field::InlineBoolean;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler::Field::Boolean';

has '+widget_wrapper' => ( default => '+ELBootstrap3' );

__PACKAGE__->meta->make_immutable;

1;
