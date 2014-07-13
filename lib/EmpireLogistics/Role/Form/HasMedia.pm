package EmpireLogistics::Role::Form::HasMedia;

use HTML::FormHandler::Moose::Role;

requires 'media_relation';

has_block 'media_block' => (
    tag         => 'fieldset',
    label       => 'Media',
    render_list => ['media', 'add_media'],
);

has_field 'item_id' => (
    type     => 'Hidden',
    accessor => 'id',
    readonly => 1,
    disabled => 1,
);
has_field 'media' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 0,
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Simple',
        tags           => {wrapper_tag => 'fieldset', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Simple',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'media.contains' => (type => '+Media',);

has_field 'add_media' => (
    type          => 'AddElement',
    repeatable    => 'media',
    value         => 'Add another media',
    element_class => ['btn btn-info']
);

no HTML::FormHandler::Moose::Role;

1;
