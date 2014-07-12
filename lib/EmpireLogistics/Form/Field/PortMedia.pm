package EmpireLogistics::Form::Field::PortMedia;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'PrintableAndNewline',
    'NotAllDigits');
extends 'EmpireLogistics::Form::Field::ELCompound';
with 'EmpireLogistics::Role::Form::Util';
use Data::Printer;

has '+widget'         => (default => '+EmpireLogistics::Form::Widget::Field::Media');

has 'item' =>
    (is => 'rw', clearer => 'clear_item', lazy => 1, builder => 'build_item');

sub build_item {
    my $self = shift;
    my $pm;
    #warn p $self->form->item;
    #return $self->form->item->find_related('port_medias', {media => $self->field('id')->fif});
    if ($self->form->item && $self->form->item->port_medias->count && $self->field('id')->fif) {
        $pm = $self->form->item->port_medias->find({media => $self->field('id')->fif})->media;
        #$pm = $self->form->item->port_medias->first->media;
    }
    return $pm;
}

has_field 'id' => (
    type  => 'PrimaryKey',
    label => 'PortMedia ID',
);
has_field 'file' => (
    label        => 'File:',
    type         => 'Upload',
    widget       => 'Upload',
    max_size     => '5242880',
    title        => '',
    element_attr => {'accept' => 'image/*',}
);

has_field 'blog_tag' => (
    type          => 'Display',
    label         => 'Blog Tag',
    render_method => \&render_blog_tag,
);

sub render_blog_tag {
    my $self      = shift;
    my $id        = $self->parent->field('id')->fif;
    my $parent_id = $self->parent->id;
    my $value     = $id ? "[MediaID:$id]<br>" : "";
    my $placeholder = "Media not saved yet";
    my $output =
        qq{<div class="form-group"><label class="col-lg-2 control-label" for="$parent_id.blog_tag">};
    $output .= $self->label;
    $output .= qq{</label><div class="col-lg-5">};
    $output .=
        qq{<input type="text" class="form-control" placeholder="$placeholder" value="$value" id="$parent_id.blog_tag" readonly="1" /><p class="small">Paste blog tag into your blog img src to display image.</p></div></div>};
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

has_field 'rm_element' => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->media_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rel-self="media" data-rep-elem-id="$id">Remove</span></div>};
}

sub validate_file {
    my $self = shift;
    return 1;
}

sub validate {
    my $self = shift;
    my $file = $self->field('file')->value;
    if (!$file) {
        $self->field('file')
            ->add_error("You must upload a file for a new media")
            unless $self->item
            && $self->item
            && $self->item->in_storage;
    }
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

