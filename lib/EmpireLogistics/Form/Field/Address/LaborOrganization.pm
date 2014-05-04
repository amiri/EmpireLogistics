package EmpireLogistics::Form::Field::Address::LaborOrganization;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::Address';
with 'EmpireLogistics::Role::Form::Util';

sub build_wrapper_class { [''] }
has '+widget_wrapper' => ( default => 'Bootstrap3' );
has '+do_wrapper'     => ( default => 1 );
has '+do_label'       => ( default => 0 );
has '+widget_tags'    => ( default => sub { { wrapper_tag => 'fieldset' } } );

has_field 'labor_organization_address' => (
    type => '+LaborOrganizationAddress',

);

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

