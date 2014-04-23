# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganizationFinance --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganizationFinance;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'LaborOrganizationFinance' );



    has_field 'total_expenses' => ( type => 'Integer', );

    has_field 'education_expenses' => ( type => 'Integer', );

    has_field 'employee_salary_expenses' => ( type => 'Integer', );

    has_field 'officer_salary_expenses' => ( type => 'Integer', );

    has_field 'strike_benefits_expenses' => ( type => 'Integer', );

    has_field 'union_administration_expenses' => ( type => 'Integer', );

    has_field 'general_overhead_expenses' => ( type => 'Integer', );

    has_field 'gifts_expenses' => ( type => 'Integer', );

    has_field 'political_expenses' => ( type => 'Integer', );

    has_field 'representation_expenses' => ( type => 'Integer', );

    has_field 'total_income' => ( type => 'Integer', );

    has_field 'liabilities' => ( type => 'Integer', );

    has_field 'assets' => ( type => 'Integer', );

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




