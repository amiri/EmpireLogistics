package EmpireLogistics::Form::Field::Address::LaborOrganization;

use HTML::FormHandler::Moose;
extends 'EmpireLogistics::Form::Field::Address';
with 'EmpireLogistics::Role::Form::Util';

has_field 'labor_organization_address' => (
    type => '+LaborOrganizationAddress',
);

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;

