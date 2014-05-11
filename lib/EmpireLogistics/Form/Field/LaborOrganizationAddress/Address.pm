package EmpireLogistics::Form::Field::LaborOrganizationAddress::Address;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::Address';
with 'EmpireLogistics::Role::Form::Util';

sub build_wrapper_class { [''] }
has '+widget_wrapper' => ( default => 'Bootstrap3' );
has '+do_wrapper'     => ( default => 1 );
has '+do_label'       => ( default => 0 );
has '+widget_tags'    => ( default => sub { { wrapper_tag => 'fieldset' } } );
sub build_element_wrapper_class {
    ['col-lg-10']
}

# This is to allow us to save edit_history for this field.
has 'item' => (
    is      => 'rw',
    clearer => 'clear_item',
    lazy    => 1,
    builder => '_build_item'
);

sub _build_item {
    my $self    = shift;
    return unless $self->field('id')->fif;
    my $address = $self->form->item->labor_organization_addresses->find({
        address => $self->field('id')->fif,
    })->address;
    return $address;
}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;
