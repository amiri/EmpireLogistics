package EmpireLogistics::Form::Base;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler';

has '+field_name_space' => ( default => 'EmpireLogistics::Form::Field');
has '+widget_name_space' => ( default => 'EmpireLogistic::Form::Widget');
has '+widget_wrapper' => ( default => 'Bootstrap' );
has '+is_html5' => (default => 1);

__PACKAGE__->meta->make_immutable;

1;
