# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganizationBenefitDisbursement --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganizationBenefitDisbursement;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'LaborOrganizationBenefitDisbursement' );



    has_field 'paid_to' => ( type => 'TextArea', );

    has_field 'description' => ( type => 'TextArea', );

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

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




