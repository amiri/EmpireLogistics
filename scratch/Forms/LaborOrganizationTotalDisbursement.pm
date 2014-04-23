# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganizationTotalDisbursement --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganizationTotalDisbursement;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'LaborOrganizationTotalDisbursement' );



    has_field 'withheld_not_disbursed' => ( type => 'Integer', );

    has_field 'withheld' => ( type => 'Integer', );

    has_field 'union_administration' => ( type => 'Integer', );

    has_field 'taxes' => ( type => 'Integer', );

    has_field 'strike_benefits' => ( type => 'Integer', );

    has_field 'representation' => ( type => 'Integer', );

    has_field 'professional_services' => ( type => 'Integer', );

    has_field 'political' => ( type => 'Integer', );

    has_field 'per_capita_tax' => ( type => 'Integer', );

    has_field 'other_union_administration' => ( type => 'Integer', );

    has_field 'other_representation' => ( type => 'Integer', );

    has_field 'other_political' => ( type => 'Integer', );

    has_field 'other_general_overhead' => ( type => 'Integer', );

    has_field 'other_contributions' => ( type => 'Integer', );

    has_field 'other' => ( type => 'Integer', );

    has_field 'office_supplies' => ( type => 'Integer', );

    has_field 'officers_total' => ( type => 'Integer', );

    has_field 'officer_salaries' => ( type => 'Integer', );

    has_field 'officer_administration' => ( type => 'Integer', );

    has_field 'members' => ( type => 'Integer', );

    has_field 'loans_paid' => ( type => 'Integer', );

    has_field 'loans_made' => ( type => 'Integer', );

    has_field 'investments' => ( type => 'Integer', );

    has_field 'general_overhead' => ( type => 'Integer', );

    has_field 'fees' => ( type => 'Integer', );

    has_field 'employees_total' => ( type => 'Integer', );

    has_field 'employee_salaries' => ( type => 'Integer', );

    has_field 'education' => ( type => 'Integer', );

    has_field 'contributions' => ( type => 'Integer', );

    has_field 'benefits' => ( type => 'Integer', );

    has_field 'affiliates' => ( type => 'Integer', );

    has_field 'administration' => ( type => 'Integer', );

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




