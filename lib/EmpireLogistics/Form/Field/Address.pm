package EmpireLogistics::Form::Field::Address;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::ELCompound';
with 'EmpireLogistics::Role::Form::Util';

# This is to allow us to save edit_history for this field.
has 'item' => (
    is      => 'rw',
    clearer => 'clear_item',
    lazy    => 1,
    builder => '_build_item'
);

sub _build_item {
    my $self = shift;
    return unless $self->field('id')->fif;
    my $address =
        $self->form->item->addresses->find({id => $self->field('id')->fif});
    return $address;
}

has_field 'id' => (
    type  => 'PrimaryKey',
    label => 'Address ID',
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
    inflate_method => \&inflate_delete_time,
);
has_field 'street_address' => (label => 'Street Address', type => 'Text',);
has_field 'postal_code'    => (type  => 'Text',);
has_field 'city'           => (type  => 'Text',);
has_field 'state'          => (type  => 'Text',);
has_field 'country'        => (type  => 'Text',);
has_field 'rm_element'     => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element,
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->address_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rel-self="address" data-rep-elem-id="$id">Remove</span></div>};
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
