package EmpireLogistics::Form::Admin::Company;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('PrintableAndNewline', 'NotAllDigits');
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'company-form');
has '+item_class' => (default => 'Company');
has 'address_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'company_addresses',
);
has 'js_files' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        ['/js/admin/company.js',];
    },
);

sub build_render_list {
    return [
        'metadata_block',  'basic_block',   'decisions_block',
        'relations_block', 'address_block', 'submit',
    ];
}

has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => ['id', 'create_time', 'update_time', 'delete_time',],
);
has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => ['name', 'description', 'company_type',],
);

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => ['ports', 'rail_nodes', 'rail_lines', 'warehouses'],
);
has_block 'decisions_block' => (
    tag         => 'fieldset',
    label       => 'Decisions',
    render_list => ['nlrb_decisions', 'osha_citations',],
);

# Addresses
has_block 'address_block' => (
    tag           => 'fieldset',
    render_list   => ['addresses', 'add_address'],
    label         => 'Addresses',
    wrapper_class => 'addresses',
);

has_field 'id' => (
    type     => 'Integer',
    #disabled => 1,
    readonly => 1,
    label    => 'Company ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    #readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    #readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_delete_time,
);

has_field 'name' => (
    type     => 'Text',
    label    => 'Name',
    required => 1,
    apply    => [PrintableAndNewline, NotAllDigits],
);
has_field 'description' => (
    type => 'TextArea', element_wrapper_class => ['col-lg-10'],
);
has_field 'company_type' => (type => '+CompanyType',);

has_field 'addresses' => (
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
has_field 'addresses.contains' => (type => '+Address',);

has_field 'add_address' => (
    type          => 'AddElement',
    repeatable    => 'addresses',
    value         => 'Add another address',
    element_class => ['btn btn-info']
);

has_field 'ports'          => (type => '+Port',);
has_field 'rail_nodes'     => (type => '+RailNode',);
has_field 'rail_lines'     => (type => '+RailLine',);
has_field 'warehouses'     => (type => '+Warehouse',);
has_field 'nlrb_decisions' => (type => '+NLRBDecision',);
has_field 'osha_citations' => (type => '+OSHACitation',);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-0', 'buffer'],
);

__PACKAGE__->meta->make_immutable;

1;
