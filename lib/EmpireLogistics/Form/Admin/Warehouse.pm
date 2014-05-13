package EmpireLogistics::Form::Admin::Warehouse;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'Printable', 'NotAllDigits' );
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'warehouse-form');
has '+item_class' => (default => 'Warehouse');
has 'address_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'warehouse_addresses',
);

has 'js_files' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        ['/js/admin/warehouse.js',];
    },
);

sub build_render_list {
    return [
        'metadata_block',  'basic_block', 'location_block',
        'relations_block', 'submit',
    ];
}
has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => ['id', 'create_time', 'update_time', 'delete_time',],
);

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => [
        'labor_organizations', 'companies',
        'work_stoppages',      'osha_citations',
        'nlrb_decisions',
    ],
);

has_field 'labor_organizations' => (type => '+LaborOrganization',);
has_field 'companies'           => (type => '+Company',);
has_field 'work_stoppages'      => (type => '+WorkStoppage',);
has_field 'nlrb_decisions'      => (type => '+NLRBDecision',);
has_field 'osha_citations'      => (type => '+OSHACitation',);

has_block 'basic_block' => (
    tag   => 'fieldset',
    label => 'Basic Information',
    render_list =>
        ['name', 'owner', 'status', 'date_opened', 'area', 'description',],
);

# Addresses
has_block 'address_block' => (
    tag           => 'fieldset',
    render_list   => ['addresses', 'add_address'],
    label         => 'Addresses',
    wrapper_class => 'addresses',
);

has_block 'location_block' => (
    tag         => 'fieldset',
    label       => 'Location',
    render_list => ['address_block', 'latitude', 'longitude', 'geometry',],
);

has_field 'id' => (
    type  => 'Hidden',
    label => 'Warehouse ID',
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
has_field 'date_opened' => (
    type            => 'YMTimestamp',
    label           => 'Date Opened',
    format          => "%Y-%m",
    html5_type_attr => 'datetime',
);

has_field 'longitude' => (type => 'Text', required => 1,);
has_field 'latitude'  => (type => 'Text', required => 1,);
has_field 'geometry'  => (type => 'Text', disabled => 1, readonly => 1,);

has_field 'name' => (type => 'Text', required => 1,);
has_field 'status' => (
    type         => 'Select',
    empty_select => '-- Select One --',
);

sub options_status {
    my $self = shift;
    return [
        map { {label => $_, value => $_,} } @{
            $self->schema->resultset($self->item_class)
                ->result_source->column_info('status')->{extra}{list}
        }
    ];
}
has_field 'owner' => (type => 'Select',);

sub options_owner {
    my $self = shift;
    return $self->schema->resultset('WarehouseOwner')->form_options;
}
has_field 'description'         => (type => 'TextArea', element_wrapper_class => ['col-lg-10'], apply => [Printable, NotAllDigits],);
has_field 'area' => (type => 'Integer', label => 'Area (square feet)');
has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
);

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

sub options_addresses {
    my $self = shift;
    my $options =
        [map { {label => $_->addresses->street_address, value => $_->id,} }
            $self->item->addresses->active->all];
    return $options;
}

__PACKAGE__->meta->make_immutable;

1;
