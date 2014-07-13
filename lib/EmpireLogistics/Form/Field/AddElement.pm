package EmpireLogistics::Form::Field::AddElement;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Render::Util ('process_attrs');
use namespace::autoclean;
extends 'HTML::FormHandler::Field::AddElement';

sub build_wrapper_class { [''] }
sub build_element_wrapper_class {
    ['']
}

__PACKAGE__->meta->make_immutable;

1;
