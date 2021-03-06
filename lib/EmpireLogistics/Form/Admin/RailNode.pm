package EmpireLogistics::Form::Admin::RailNode;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'PrintableAndNewline', 'NotAllDigits');
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';

has '+name'       => (default => 'rail-node-form');
has '+item_class' => (default => 'RailNode');
has '+enctype'           => (default => 'multipart/form-data');


has 'address_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'rail_node_addresses',
);

has 'media_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'rail_node_medias',
);

has 'js_files' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [
            '/js/admin/rail-node.js',
            '/js/admin/repeatable_media.js',
        ];
    },
);

with 'EmpireLogistics::Role::Form::Util';
with 'EmpireLogistics::Role::Form::HasMedia';


sub build_render_list {
    return ['metadata_block', 'basic_block', 'media_block', 'location_block',
        'relations_block', 'submit',];
}
has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => ['id', 'item_id', 'create_time', 'update_time', 'delete_time',],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => ['name', 'junction_id', 'incident_links', 'description',],
);

has_block 'location_block' => (
    tag         => 'fieldset',
    label       => 'Location',
    render_list => ['latitude', 'longitude', 'geometry', 'address_block',],
);

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => ['companies', 'labor_organizations', 'work_stoppages',],
);

has_field 'id' => (
    type     => 'Integer',
    disabled => 1,
    readonly => 1,
    label    => 'RailNode ID',
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
    deflate_method => \&deflate_time,
);
has_field 'junction_id' => (
    type  => 'Integer',
    label => 'Junction ID',
);
has_field 'name' => (
    type     => 'Text',
    label    => 'Node Name',
    required => 1,
);
has_field 'incident_links' => (
    type  => 'Integer',
    label => 'Links',
);
has_field 'description' => (
    type => 'TextArea', element_wrapper_class => ['col-lg-10'],
);

# Location
has_field 'longitude' => (type => 'Text', required => 1,);
has_field 'latitude'  => (type => 'Text', required => 1,);
has_field 'geometry'  => (type => 'Text', disabled => 1, readonly => 1,);

# Companies
has_field 'companies' => (
    type => '+Company',
);

# Labor Organizations
has_field 'labor_organizations' => (
    type => '+LaborOrganization',
);

# Work Stoppages
has_field 'work_stoppages' => (
    type => '+WorkStoppage',
);

# Addresses
has_block 'address_block' => (
    tag           => 'fieldset',
    render_list   => ['addresses', 'add_address'],
    label         => 'Addresses',
    wrapper_class => 'addresses',
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

#sub options_addresses {
    #my $self = shift;
    #my $options =
        #[map { {label => $_->addresses->street_address, value => $_->id,} }
            #$self->item->addresses->active->all];
    #return $options;
#}

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-0', 'buffer'],
);

__PACKAGE__->meta->make_immutable;

1;
