package EmpireLogistics::Form::Field::LaborOrganizationOfficerDisbursement;

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
        $self->form->item->labor_organization_officer_disbursements->find(
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
has_field 'first_name'   => (type => 'Text',);
has_field 'middle_name'   => (type => 'Text',);
has_field 'last_name'   => (type => 'Text',);
has_field 'title'   => (type => 'Text',);
has_field 'administration_percent'   => (type => 'Integer',);
has_field 'contributions_percent'   => (type => 'Integer',);
has_field 'general_overhead_percent'   => (type => 'Integer',);
has_field 'gross_salary'   => (type => 'Integer',);
has_field 'political_percent'   => (type => 'Integer',);
has_field 'representation_percent'   => (type => 'Integer',);
has_field 'total'   => (type => 'Integer',);

has_field 'rm_element' => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element,
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->officer_disbursement_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rep-elem-id="$id">Remove</span></div>};
}

sub validate {
    my $self          = shift;
    my $year_required = 0;
    $year_required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('year')->add_error("Officer disbursement year required")
        if $year_required;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
