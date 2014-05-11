package EmpireLogistics::Form::Field::LaborOrganizationFixedAsset;

use HTML::FormHandler::Moose;
use List::AllUtils qw/any/;
extends 'EmpireLogistics::Form::Field::LaborOrganizationCompound';
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
    my $asset = $self->form->item->labor_organization_fixed_assets->find(
        {
            id => $self->field('id')->fif,
        }
    );
    return $asset;
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
has_field 'year' => (type => 'Year', empty_select => '-- Select One --',);
has_field 'asset_type' => (
    type           => 'Select',
    empty_select   => '-- Select One --',
    options_method => \&options_asset_type,
);

sub options_asset_type {
    my $self = shift;
    return [
        map { {label => $_, value => $_,} } @{
            $self->form->schema->resultset("LaborOrganizationFixedAsset")
                ->result_source->column_info('asset_type')->{extra}{list}
        }
    ];
}
has_field 'book_value'   => (type => 'Integer',);
has_field 'cost_basis'   => (type => 'Integer',);
has_field 'depreciation' => (type => 'Integer',);
has_field 'value'        => (type => 'Integer',);
has_field 'description'  => (type => 'Text',);

has_field 'rm_element' => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element,
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->fixed_asset_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rep-elem-id="$id">Remove</span></div>};
}

sub validate {
    my $self          = shift;
    my $year_required = 0;
    $year_required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('year')->add_error("Fixed asset year required")
        if $year_required;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

