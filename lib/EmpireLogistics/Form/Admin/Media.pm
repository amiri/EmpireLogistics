package EmpireLogistics::Form::Admin::Media;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'PrintableAndNewline',
    'NotAllDigits');
use MooseX::Types::URI qw/FileUri/;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'               => (default => 'media-form');
has '+item_class'         => (default => 'Media');
has '+enctype'            => (default => 'multipart/form-data');
has 'js_files' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [
            '/js/lib/cropper/cropper.min.js',
            '/js/admin/media.js',
        ];
    },
);
has 'stylesheets' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [
            '/js/lib/cropper/cropper.min.css',
        ];
    },
);

sub build_render_list {
    return [
        'metadata_block',  'basic_block', 'annotations_block',
        'relations_block', 'submit',
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
    render_list => ['file', 'preview', 'blog_tag', 'data-x1', 'data-y1', 'data-x2', 'data-y2', 'data-height', 'data-width','uuid', 'mime_type', 'width', 'height'],
);

has_block 'annotations_block' => (
    tag         => 'fieldset',
    label       => 'Annotations',
    render_list => ['caption', 'alt', 'description'],
);

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => ['ports', 'rail_nodes', 'warehouses'],
);

has_field 'id' => (
    type => 'Integer',

    #disabled => 1,
    readonly => 1,
    label    => 'Media ID',
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

has_field 'file' => (
    label    => 'File',
    type     => 'Upload',
    widget   => 'Upload',
    max_size => 5242880,

    #min_size     => 524288,
    title => '',
    element_attr =>
        {'accept' => 'image/*', "data-ajax-url" => '/admin/media/add-media'},
);

has_field 'preview' => (
    label         => 'Preview',
    type          => 'Display',
    render_method => \&render_preview,
);

has_field 'blog_tag' => (
    type          => 'Display',
    label         => 'Blog Tag',
    render_method => \&render_blog_tag,
);

sub render_blog_tag {
    my $self      = shift;
    my $id        = $self->form->field('id')->fif;
    my $value     = $id ? "[MediaID:$id]<br>" : "";
    my $placeholder = "Media not saved yet";
    my $output =
        qq{<div class="form-group"><label class="col-lg-2 control-label" for="blog_tag">};
    $output .= $self->label;
    $output .= qq{</label><div class="col-lg-5">};
    $output .=
        qq{<input type="text" class="form-control" placeholder="$placeholder" value="$value" id="blog_tag" readonly="1" /><p class="small">Paste blog tag into your blog where you would like to display the image.</p></div></div>};
    return $output;
}


has_field 'data-x1' => (
    type => 'Hidden',
);
has_field 'data-y1' => (
    type => 'Hidden',
);
has_field 'data-x2' => (
    type => 'Hidden',
);
has_field 'data-y2' => (
    type => 'Hidden',
);
has_field 'data-height' => (
    type => 'Hidden',
);
has_field 'data-width' => (
    type => 'Hidden',
);


sub render_preview {
    my $self  = shift;
    my $id    = $self->id;
    my $media = $self->parent->item;
    my $output =
        qq{<div class="form-group"><label class="col-lg-2 control-label" for="$id">};
    $output .= $self->label;
    $output .= qq{</label>};
    $output .= qq{<div class="col-lg-5">};
    my $url = $media ? $media->file_url : '';
    $output .= qq{
        <div class="img-container preview">
            <img src="$url" />
        </div>
    };
    $output .= qq{</div>};
    $output .= qq{
        <div class="col-lg-3">
            <div class="row">
                <div class="img-preview"></div>

            </div>
        </div>
        <br />
        <div class="col-lg-3">
            <div class="row">
                <div class="button-group top-buffer">
                    <button type="button" name="crop" id="crop" class="btn btn-default">Crop</button>
                    <button type="button" name="disable-crop" id="disable-crop" class="btn btn-danger">Disable</button>
                    <button type="button" name="enable-crop" id="enable-crop" class="btn btn-success">Enable</button>
                </div>
            </div>
        </div>
    };
    $output .= qq{</div>};
    return $output;
}

has_field 'uuid' => (
    type     => 'Text',
    label    => 'UUID',
    apply    => [NoSpaces, PrintableAndNewline],
    required => 1,
    unique   => 1,
);

has_field 'mime_type' => (
    type         => 'Text',
    label        => 'MIME Type',
    element_attr => {readonly => 1},
);

has_field 'width' => (
    type         => 'Text',
    label        => 'Width',
    element_attr => {readonly => 1},
);

has_field 'height' => (
    type         => 'Text',
    label        => 'Height',
    element_attr => {readonly => 1},
);

has_field 'caption' => (
    type  => 'Text',
    label => 'Caption',
);

has_field 'alt' => (
    type  => 'Text',
    label => 'Alt Text',
);

has_field 'description' => (
    type  => 'TextArea',
    label => 'Description',
);

has_field 'ports'      => (type => '+Port',);
has_field 'rail_nodes' => (type => '+RailNode',);
has_field 'warehouses' => (type => '+Warehouse',);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-0', 'buffer'],
);

around 'update_model', sub {
    my ($orig, $self, @args) = @_;

    delete @{$self->values}
        {qw/data-x1 data-y1 data-x2 data-y2 data-height data-width/};

    my $return = $self->$orig(@args);

    return $return;
};

__PACKAGE__->meta->make_immutable;

1;
