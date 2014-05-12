package EmpireLogistics::Form::Field::ELCompound;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Field::Compound';

sub build_wrapper_class { [''] }
sub build_element_wrapper_class {
    ['col-lg-10', 'compact-field']
}
has '+widget_wrapper' => (default => 'Bootstrap3');
has '+do_wrapper'     => (default => 1);
has '+do_label'       => (default => 0);
has '+widget_tags'    => (default => sub { {wrapper_tag => 'fieldset'} });

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;

1;
