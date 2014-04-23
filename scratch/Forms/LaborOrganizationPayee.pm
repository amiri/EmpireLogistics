# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganizationPayee --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganizationPayee;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;



    use DateTime;





    has '+item_class' => ( default => 'LaborOrganizationPayee' );



    has_field 'usdol_payee_id' => ( type => 'Integer', );

    has_field 'amount' => ( type => 'Integer', );

    has_field 'payment_type' => ( type => 'TextArea', );

    has_field 'payee_type' => ( type => 'Text', );

    has_field 'name' => ( type => 'TextArea', required => 1, );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization_payee_addresses' => ( type => '+LaborOrganizationPayeeAddressField', );

    has_field 'labor_organization' => ( type => 'Select', );

    has_field 'labor_organization_general_disbursements' => ( type => '+LaborOrganizationGeneralDisbursementField', );

    has_field 'labor_organization_other_receipts' => ( type => '+LaborOrganizationOtherReceiptField', );

    has_field 'edits' => ( type => '+EditHistoryField', );

    has_field 'submit' => ( widget => 'Submit', );



    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EditHistoryField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'notes' => ( type => 'TextArea', );

    has_field 'object' => ( type => 'Integer', required => 1, );

    has_field 'object_type' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'admin' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package LaborOrganizationOtherReceiptField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'purpose' => ( type => 'TextArea', );

    has_field 'receipt_date' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'receipt_date.year';        has_field 'receipt_date.month';        has_field 'receipt_date.day';

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'payee' => ( type => 'Select', );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationPayeeAddressField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization_payee' => ( type => 'Select', );

    has_field 'address' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package LaborOrganizationGeneralDisbursementField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'purpose' => ( type => 'TextArea', );

    has_field 'disbursement_type' => ( type => 'Text', );

    has_field 'disbursement_date' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'disbursement_date.year';        has_field 'disbursement_date.month';        has_field 'disbursement_date.day';

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    has_field 'payee' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}




