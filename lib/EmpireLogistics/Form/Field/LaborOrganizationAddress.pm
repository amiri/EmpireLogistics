package EmpireLogistics::Form::Field::LaborOrganizationAddress;

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
    my $self    = shift;
    my $address = $self->form->item->labor_organization_addresses->active->find({
        id => $self->field('id')->fif,
    }, { key => 'primary' });
    return $address;
}

has_field 'id' => (
    type  => 'PrimaryKey',
    label => 'Labor Organization Address ID',
);
has_field 'year' => (
    type  => 'Year',
    label => 'Year',
    empty_select => '-- Select One --',
);

has_field 'address' => ( type => '+LaborOrganizationAddress::Address', );

sub validate {
    my $self          = shift;
    my $year_required = 0;
    $year_required = 1 if any { defined $_->value } @{$self->sorted_fields};
    $self->field('year')->add_error("Labor organization year required")
        if $year_required and not $self->field("year")->value;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
