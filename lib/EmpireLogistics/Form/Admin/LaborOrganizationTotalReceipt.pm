# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganizationTotalReceipt --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganizationTotalReceipt;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'LaborOrganizationTotalReceipt' );



    has_field 'tax' => ( type => 'Integer', );

    has_field 'rents' => ( type => 'Integer', );

    has_field 'other_receipts' => ( type => 'Integer', );

    has_field 'office_supplies' => ( type => 'Integer', );

    has_field 'members' => ( type => 'Integer', );

    has_field 'loans_taken' => ( type => 'Integer', );

    has_field 'loans_made' => ( type => 'Integer', );

    has_field 'investments' => ( type => 'Integer', );

    has_field 'interest' => ( type => 'Integer', );

    has_field 'fees' => ( type => 'Integer', );

    has_field 'dues' => ( type => 'Integer', );

    has_field 'dividends' => ( type => 'Integer', );

    has_field 'all_other_receipts' => ( type => 'Integer', );

    has_field 'affiliates' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'edits' => ( type => '+EditHistoryField', );

    has_field 'labor_organization' => ( type => 'Select', );

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




