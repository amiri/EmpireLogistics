# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganizationTotalAsset --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganizationTotalAsset;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'LaborOrganizationTotalAsset' );



    has_field 'treasuries_start' => ( type => 'Integer', );

    has_field 'treasuries_end' => ( type => 'Integer', );

    has_field 'total_start' => ( type => 'Integer', );

    has_field 'securities_cost' => ( type => 'Integer', );

    has_field 'securities_book_value' => ( type => 'Integer', );

    has_field 'other_investments_cost' => ( type => 'Integer', );

    has_field 'other_investments_book_value' => ( type => 'Integer', );

    has_field 'other_assets_start' => ( type => 'Integer', );

    has_field 'other_assets_end' => ( type => 'Integer', );

    has_field 'loans_receivable_start' => ( type => 'Integer', );

    has_field 'loans_receivable_end' => ( type => 'Integer', );

    has_field 'investments_start' => ( type => 'Integer', );

    has_field 'investments_end' => ( type => 'Integer', );

    has_field 'fixed_assets_start' => ( type => 'Integer', );

    has_field 'fixed_assets_end' => ( type => 'Integer', );

    has_field 'cash_start' => ( type => 'Integer', );

    has_field 'cash_end' => ( type => 'Integer', );

    has_field 'accounts_receivable_start' => ( type => 'Integer', );

    has_field 'accounts_receivable_end' => ( type => 'Integer', );

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




