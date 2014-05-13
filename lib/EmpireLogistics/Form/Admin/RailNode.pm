package EmpireLogistics::Form::Admin::RailNode;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'Printable', 'NotAllDigits' );
use MooseX::Types::URI qw/Uri/;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'rail-node-form');
has '+item_class' => (default => 'RailNode');
has 'js_files'    => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        ['/js/admin/rail-node.js',];
    },
);

sub build_render_list {
    return ['metadata_block', 'basic_block', 'location_block','relations_block', 'submit',];
}
has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => ['id', 'create_time', 'update_time', 'delete_time',],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => ['name', 'junction_id', 'incident_links', 'description',],
);

has_block 'location_block' => (
    tag         => 'fieldset',
    label       => 'Location',
    render_list => ['latitude', 'longitude', 'geometry',],
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
    deflate_method => \&deflate_delete_time,
);
has_field 'junction_id' => (
    type     => 'Integer',
    label    => 'Junction ID',
    required => 1,
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
    type  => 'TextArea',
    label => 'Description',
    apply => [ Printable, NotAllDigits ],
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

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
);

__PACKAGE__->meta->make_immutable;

1;
