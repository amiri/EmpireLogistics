package EmpireLogistics::Form::Field::PortTonnage;

use HTML::FormHandler::Moose;
use List::AllUtils qw/any/;
extends 'EmpireLogistics::Form::Field::ELCompound';
with 'EmpireLogistics::Role::Form::Util';

has '+widget' => (default => '+EmpireLogistics::Form::Widget::Field::BorderedCompound');
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
    my $tonnage = $self->form->item->port_tonnages->find({id => $self->field('id')->fif}, {key => 'primary'});
    return $tonnage;
}

has_field 'id' => (
    type  => 'PrimaryKey',
    label => 'PortTonnage ID',
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
    inflate_method => \&inflate_time,
);
has_field 'year' => (
    type  => 'Year',
    label => 'Year',
    empty_select => '-- Select One --',
);
has_field 'domestic_tonnage' => (label => 'Domestic Tonnage', type => 'Integer',);
has_field 'foreign_tonnage' => (label => 'Foreign Tonnage', type => 'Integer',);
has_field 'import_tonnage' => (label => 'Import Tonnage', type => 'Integer',);
has_field 'export_tonnage' => (label => 'Export Tonnage', type => 'Integer',);
has_field 'total_tonnage' => (label => 'Total Tonnage', type => 'Integer',);

has_field 'rm_element'     => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element,
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->tonnage_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rel-self="tonnage" data-rep-elem-id="$id">Remove</span></div>};
}

sub validate {
    my $self          = shift;
    my $year_required = 0;
    $year_required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('year')->add_error("Port tonnage year required")
        if $year_required and not $self->field("year")->value;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

