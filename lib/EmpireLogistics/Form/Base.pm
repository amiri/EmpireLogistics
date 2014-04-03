package EmpireLogistics::Form::Base;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler';

has '+field_name_space' => ( default => 'EmpireLogistics::Form::Field');
has '+widget_name_space' => ( default => 'EmpireLogistic::Form::Widget');
has '+widget_wrapper' => ( default => 'Bootstrap3' );
has '+is_html5' => (default => 1);
has '+http_method' => (default => 'post');

sub build_form_element_attr { { 'accept-charset' => 'utf-8' } }
sub build_form_element_class { ['form-vertical'] }

__PACKAGE__->meta->make_immutable;

1;
