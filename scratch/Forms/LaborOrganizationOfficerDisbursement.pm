# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganizationOfficerDisbursement --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganizationOfficerDisbursement;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'LaborOrganizationOfficerDisbursement' );



    has_field 'total' => ( type => 'Integer', );

    has_field 'representation_percent' => ( type => 'Integer', );

    has_field 'political_percent' => ( type => 'Integer', );

    has_field 'gross_salary' => ( type => 'Integer', );

    has_field 'general_overhead_percent' => ( type => 'Integer', );

    has_field 'contributions_percent' => ( type => 'Integer', );

    has_field 'administration_percent' => ( type => 'Integer', );

    has_field 'title' => ( type => 'TextArea', );

    has_field 'last_name' => ( type => 'TextArea', );

    has_field 'middle_name' => ( type => 'TextArea', );

    has_field 'first_name' => ( type => 'TextArea', );

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




