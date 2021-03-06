package EmpireLogistics::Form::Field::Media;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'PrintableAndNewline', 'NotAllDigits');
use List::AllUtils qw/any/;
extends 'EmpireLogistics::Form::Field::ELCompound';
with 'EmpireLogistics::Role::Form::Util';

has '+widget' => (default => '+EmpireLogistics::Form::Widget::Field::Media');
has 'item'    => (is => 'rw', clearer => 'clear_item', lazy => 1, builder => 'build_item');

sub build_item {
    my $self = shift;
    my $m;
    $m = $self->form->item->find_related($self->form->media_relation,
        {media => $self->field('id')->fif})
        if $self->field('id')->fif;
    return $m;
}

has_field 'id' => (
    type  => 'PrimaryKey',
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
        qq{<input type="text" class="form-control" placeholder="$placeholder" value="$value" id="$parent_id.blog_tag" readonly="1" /><p class="small">Paste blog tag into your blog where you would like to display the image.</p></div></div>};
    return $output;
}

has_field 'uuid' => (
    type     => 'Text',
    label    => 'UUID',
    apply    => [NoSpaces, PrintableAndNewline],
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
    my $uuid_required = 0;
    $uuid_required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('uuid')->add_error("UUID required")
        if $uuid_required and not $self->field("uuid")->value;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

