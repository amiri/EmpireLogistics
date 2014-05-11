package EmpireLogistics::Form::Field::LaborOrganizationPayee::Single;

use HTML::FormHandler::Moose;
use Data::Printer;
extends 'EmpireLogistics::Form::Field::BaseSelect2::Single';
with 'EmpireLogistics::Role::Form::Util';

sub build_label { 'Payee' }
sub build_id { 'labor-organization-payee-single' }
sub build_element_attr { { 'data-placeholder'  => 'Enter Payee' } }
#sub build_element_wrapper_class {
    #['col-lg-10']
#}

no HTML::FormHandler::Moose;

__PACKAGE__->meta->make_immutable;

1;


