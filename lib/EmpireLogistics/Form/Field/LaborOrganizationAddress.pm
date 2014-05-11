package EmpireLogistics::Form::Field::LaborOrganizationAddress;

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
    my $self    = shift;
    my $address = $self->form->item->labor_organization_addresses->active->find({
        id => $self->field('id')->fif,
    });
    return $address;
}

has_field 'id' => (
    type  => 'PrimaryKey',
    label => 'Labor Organization Address ID',
);
has_field 'year' => (
    type  => 'Year',
    label => 'Year',
    default_method => \&default_year,
);
sub default_year {
    my $self = shift;
    return DateTime->now->year;
}

has_field 'address' => ( type => '+LaborOrganizationAddress::Address', );

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
