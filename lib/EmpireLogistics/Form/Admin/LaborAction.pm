package EmpireLogistics::Form::Admin::LaborAction;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'Printable', 'NotAllDigits', );
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'labor-action-form' );
has '+item_class' => ( default => 'WorkStoppage' );
has 'js_files' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [ '/js/admin/labor-action.js', ];
    },
);

sub build_render_list {
    return [
        'metadata_block',
        'basic_block',
        'relations_block',
        'submit',
    ];
}

has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => [
        'id',
        'create_time',
        'update_time',
        'delete_time',
    ],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => [
        'name',
        'work_stoppage_type',
        'start_date',
        'end_date',
        'description',
    ],
);

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => [
        'labor_organizations',
        'ports',
        'rail_lines',
        'rail_nodes',
        'warehouses',
    ],
);

has_field 'labor_organizations' => (
    type => '+LaborOrganization',
);
has_field 'ports' => (
    type => '+Port',
);
has_field 'rail_lines' => (
    type => '+RailLine',
);
has_field 'rail_nodes' => (
    type => '+RailNode',
);
has_field 'warehouses' => (
    type => '+Warehouse',
);

has_field 'id' => (
    type  => 'Integer',
    disabled => 1,
    readonly => 1,
    label => 'Labor Action ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_delete_time,
);

has_field 'name' => ( type => 'Text', required => 1, );
has_field 'work_stoppage_type' => (
    type => 'Select',
    label => 'Labor Action Type',
    required => 1,
    empty_select => '-- Select One --',
);

sub options_work_stoppage_type {
    my $self = shift;
    return $self->schema->resultset('WorkStoppageType')->form_options;
}

has_field 'description'         => (type => 'TextArea', element_wrapper_class => ['col-lg-10'], apply => [Printable, NotAllDigits],);
has_field 'start_date' => (
    type            => 'Date',
    label           => 'Start Date',
    html5_type_attr => 'date',
    required => 1,
);
has_field 'end_date' => (
    type            => 'Date',
    label           => 'End Date',
    html5_type_attr => 'date',
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
);


__PACKAGE__->meta->make_immutable;

1;
