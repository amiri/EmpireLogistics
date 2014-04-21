package EmpireLogistics::Form::Admin::Warehouse;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'Printable' );
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'warehouse-form' );
has '+item_class' => ( default => 'Warehouse' );

sub build_render_list {
    return [
        'metadata_block',
        'basic_block',
        'location_block',
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
        'owner',
        'status',
        'date_opened',
        'area',
        'description',
    ],
);

has_block 'location_block' => (
    tag         => 'fieldset',
    label       => 'Location',
    render_list => [
        'latitude',
        'longitude',
        'geometry',
    ],
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
    type           => 'YMTimestamp',
    label          => 'Date Opened',
    format          => "%Y-%m",
    html5_type_attr => 'datetime',
);

has_field 'longitude' => ( type => 'Text', required => 1, );
has_field 'latitude' => ( type => 'Text', required => 1, );
has_field 'geometry' => ( type => 'Text', disabled => 1, readonly => 1, );

has_field 'name' => ( type => 'Text', required => 1, );
has_field 'status' => ( type => 'Text', );
has_field 'owner' => ( type => 'Select', );
sub options_owner {
    my $self = shift;
    return $self->schema->resultset('WarehouseOwner')->form_options;
}
has_field 'description' => ( type => 'TextArea', );
has_field 'area' => ( type => 'Integer', label => 'Area (square feet)' );
has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
);

__PACKAGE__->meta->make_immutable;

1;
