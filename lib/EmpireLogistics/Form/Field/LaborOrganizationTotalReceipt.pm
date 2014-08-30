package EmpireLogistics::Form::Field::LaborOrganizationTotalReceipt;

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
    my $receipt = $self->form->item->labor_organization_total_receipts->find(
        {
            id => $self->field('id')->fif,
        }, {key => 'primary'}
    );
    return $receipt;
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
    deflate_method => \&deflate_time,
    #inflate_method => \&inflate_time,
);

has_field 'year' => (type => 'Year', empty_select => '-- Select One --',);
has_field 'affiliates' => (type => 'Integer');
has_field 'all_other_receipts' => (type => 'Integer');
has_field 'dividends' => (type => 'Integer');
has_field 'dues' => (type => 'Integer');
has_field 'fees' => (type => 'Integer');
has_field 'interest' => (type => 'Integer');
has_field 'investments' => (type => 'Integer');
has_field 'loans_made' => (type => 'Integer');
has_field 'loans_taken' => (type => 'Integer');
has_field 'members' => (type => 'Integer');
has_field 'office_supplies' => (type => 'Integer');
has_field 'other_receipts' => (type => 'Integer');
has_field 'rents' => (type => 'Integer');
has_field 'tax' => (type => 'Integer');

has_field 'rm_element' => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element,
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->total_receipt_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rep-elem-id="$id">Remove</span></div>};
}

sub validate {
    my $self          = shift;
    my $year_required = 0;
    $year_required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('year')->add_error("Total receipt year required")
        if $year_required and not $self->field("year")->value;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

