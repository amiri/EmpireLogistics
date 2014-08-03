package EmpireLogistics::Form::Field::LaborOrganizationGeneralDisbursement;

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
    my $asset =
        $self->form->item->labor_organization_general_disbursements->find(
        {
            id => $self->field('id')->fif,
        }, {key => 'primary'}
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
has_field 'year'   => (type => 'Year', empty_select => '-- Select One --',);
has_field 'disbursement_date'   => (type => 'Date',);
has_field 'amount' => (type => 'Integer',);
has_field 'purpose' => (type => 'TextArea',);
has_field 'payee' => (type => 'Select', empty_select => '-- Select One --', options_method => \&options_payee, );
sub options_payee {
    my $self = shift;
    return [
        map {{
            label => $_->name.' (USDOL Payee #'.$_->usdol_payee_id.')',
            id => $_->id,
        }} ($self->form->item ? $self->form->item->labor_organization_payees->all : $self->form->schema->resultset('LaborOrganizationPayee')->active->all)
    ];
}
has_field 'disbursement_type' => (
    type           => 'Select',
    empty_select   => '-- Select One --',
    options_method => \&options_disbursement_type,
);

sub options_disbursement_type {
    my $self = shift;
    return [
        map { {label => $_, value => $_,} } @{
            $self->form->schema->resultset("LaborOrganizationGeneralDisbursement")
                ->result_source->column_info('disbursement_type')->{extra}{list}
        }
    ];
}

has_field 'rm_element' => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element,
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->general_disbursement_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rep-elem-id="$id">Remove</span></div>};
}

sub validate {
    my $self          = shift;
    my $required = 0;
    $required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('year')->add_error("General disbursement year required")
        if $required and not $self->field('year')->value;
    $self->field('payee')->add_error("General disbursement payee required")
        if $required and not $self->field('payee')->value;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
