package EmpireLogistics::Form::Field::LaborOrganizationAccountReceivable;

use HTML::FormHandler::Moose;
use List::AllUtils qw/any/;
extends 'HTML::FormHandler::Field::Compound';
with 'EmpireLogistics::Role::Form::Util';

sub build_wrapper_class { [''] }
has '+widget_wrapper' => (default => 'Bootstrap3');
has '+do_wrapper'     => (default => 1);
has '+do_label'       => (default => 0);
has '+widget_tags'    => (default => sub { {wrapper_tag => 'fieldset'} });

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
    my $account =
        $self->form->item->labor_organization_account_receivables->find(
        {   id => $self->field('id')->fif,
        });
    return $account;
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
has_field 'account_type' => (
    type           => 'Select',
    empty_select   => '-- Select One --',
    options_method => \&options_account_type,
);

sub options_account_type {
    my $self = shift;
    return [
        map { {label => $_, value => $_,} } @{
            $self->form->schema->resultset("LaborOrganizationAccountPayable")
                ->result_source->column_info('account_type')->{extra}{list}}];
}
has_field 'liquidated'   => (type => 'Integer',);
has_field 'name'         => (type => 'Text',);
has_field 'past_due_90'  => (type => 'Integer',);
has_field 'past_due_180' => (type => 'Integer',);
has_field 'total'        => (type => 'Integer',);

has_field 'rm_element' => (
    type          => 'Display',
    label         => "Remove and Delete",
    render_method => \&render_rm_element,
);

sub render_rm_element {
    my $self = shift;
    my $id   = $self->parent->id;
    my $rel  = $self->parent->form->account_receivable_relation;
    return
        qq{<div><span class="btn btn-danger rm_element" data-rel="$rel" data-rep-elem-id="$id">Remove</span></div>};
}

sub validate {
    my $self          = shift;
    my $year_required = 0;
    $year_required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('year')->add_error("Account receivable year required")
        if $year_required;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
