package EmpireLogistics::Form::Base;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler';

has '+field_name_space'  => (default => 'EmpireLogistics::Form::Field');
has '+widget_name_space' => (default => 'EmpireLogistics::Form::Widget');
has '+widget_wrapper'    => (default => 'Bootstrap3');
has '+is_html5'          => (default => 1);
has '+http_method'       => (default => 'post');
has '+enctype'           => (default => 'application/x-www-form-urlencoded');

sub build_form_element_attr { {'accept-charset' => 'utf-8'} }
sub build_form_element_class { ['form-horizontal'] }

sub build_form_tags {
    {
        'layout_classes' => {
            label_class                    => ['col-lg-2'],
            element_wrapper_class          => ['col-lg-5'],
            no_label_element_wrapper_class => ['col-lg-offset-1'],
        },
    };
}

__PACKAGE__->meta->make_immutable;

1;
