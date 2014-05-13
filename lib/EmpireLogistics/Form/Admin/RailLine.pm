package EmpireLogistics::Form::Admin::RailLine;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'Printable');
use MooseX::Types::URI qw/Uri/;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'rail-line-form');
has '+item_class' => (default => 'RailLine');
has 'js_files'    => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        ['/js/admin/rail-line.js',];
    },
);

sub build_render_list {
    return ['metadata_block', 'basic_block', 'details_block', 'owners_block',
        'trackage_block', 'geometry_block', 'relations_block', 'submit',];
}
has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => ['id', 'create_time', 'update_time', 'delete_time',],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => [
        'link_id',
        'route_id',
        'a_junction',
        'b_junction',
        'subdivision',
        'description',
    ],
);

has_field 'description' => (
    type  => 'TextArea',
    label => 'Description',
    apply => [ Printable, NotAllDigits ],
);
has_block 'details_block' => (
    tag         => 'fieldset',
    label       => 'Details',
    render_list => [
        'miles',
        'direction',
        'track_type',
        'grade',
        'gauge',
        'status',
        'passenger',
        'military_subsystem',
        'signal_system',
        'traffic_density',
        'line_class',
    ],
);

has_block 'owners_block' => (
    tag         => 'fieldset',
    label       => 'Owners',
    render_list => [
        'owner1',
        'owner2',
    ],

);
has_block 'trackage_block' => (
    tag         => 'fieldset',
    label       => 'Trackage Rights',
    render_list => [
        'trackage_rights1',
        'trackage_rights2',
        'trackage_rights3',
    ],

);

has_block 'geometry_block' => (
    tag         => 'fieldset',
    label       => 'Geometry',
    render_list => ['geometry',],
);

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => ['work_stoppages',],
);

has_field 'id' => (
    type     => 'Integer',
    disabled => 1,
    readonly => 1,
    label    => 'RailLine ID',
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
has_field 'link_id' => (
    type     => 'Text',
    label    => 'Link ID',
    required => 1,
);
has_field 'route_id' => (
    type     => 'Text',
    label    => 'Route ID',
);
has_field 'miles' => (
    type     => 'Text',
    label    => 'Miles',
);
has_field 'direction' => (
    type     => 'Text',
    label    => 'Direction',
);
has_field 'track_type' => (
    type  => 'Text',
    label => 'Track Type',
);
has_field 'grade' => (
    type  => 'Text',
    label => 'Track Grade',
);
has_field 'gauge' => (
    type  => 'Text',
    label => 'Track Gauge',
);
has_field 'status' => (
    type  => 'Text',
    label => 'Track Status',
);
has_field 'passenger' => (
    type  => 'Text',
    label => 'Passenger Rail?',
);
has_field 'military_subsystem' => (
    type  => 'Text',
    label => 'Military Subsystem',
);
has_field 'signal_system' => (
    type     => 'Text',
    label    => 'Signal System',
);
has_field 'traffic_density' => (
    type     => 'Text',
    label    => 'Traffic Density',
);
has_field 'line_class' => (
    type     => 'Text',
    label    => 'Line Class',
);
has_field 'a_junction' => (
    type     => 'Text',
    label    => 'Origin Junction',
);
has_field 'b_junction' => (
    type     => 'Text',
    label    => 'Destination Junction',
);
has_field 'subdivision' => (
    type     => 'Text',
    label    => 'Subdivision',
);
has_field 'owner1' => (
    type     => 'Text',
    label    => 'Primary Owner',
);
has_field 'owner2' => (
    type     => 'Text',
    label    => 'Secondary Owner',
);
has_field 'trackage_rights1' => (
    type     => 'Text',
    label    => 'Primary Trackage Rights',
);

has_field 'trackage_rights2' => (
    type     => 'Text',
    label    => 'Secondary Trackage Rights',
);
has_field 'trackage_rights3' => (
    type     => 'Text',
    label    => 'Other Trackage Rights',
);

# Location
has_field 'geometry'  => (type => 'TextArea', disabled => 1, readonly => 1,);

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

