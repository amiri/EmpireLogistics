# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=Warehouse --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::Warehouse;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;



    use DateTime;





    has '+item_class' => ( default => 'Warehouse' );



    has_field 'geometry' => ( type => 'TextArea', );

    has_field 'longitude' => ( type => 'Text', );

    has_field 'latitude' => ( type => 'Text', );

    has_field 'date_opened' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'date_opened.year';        has_field 'date_opened.month';        has_field 'date_opened.day';

    has_field 'owner' => ( type => 'Text', );

    has_field 'area' => ( type => 'Integer', );

    has_field 'status' => ( type => 'Text', );

    has_field 'description' => ( type => 'TextArea', );

    has_field 'name' => ( type => 'TextArea', );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'warehouse_work_stoppages' => ( type => '+WarehouseWorkStoppageField', );

    has_field 'warehouse_walmarts' => ( type => '+WarehouseWalmartField', );

    has_field 'edits' => ( type => '+EditHistoryField', );

    has_field 'warehouse_addresses' => ( type => '+WarehouseAddressField', );

    has_field 'company_warehouses' => ( type => '+CompanyWarehouseField', );

    has_field 'labor_organization_warehouses' => ( type => '+LaborOrganizationWarehouseField', );

    has_field 'submit' => ( widget => 'Submit', );



    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package LaborOrganizationWarehouseField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    has_field 'warehouse' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::WarehouseWorkStoppageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'work_stoppage' => ( type => 'Select', );

    has_field 'warehouse' => ( type => 'Select', );

    

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

    package EmpireLogistics::Form::Admin::WarehouseAddressField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'address' => ( type => 'Select', );

    has_field 'warehouse' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::WarehouseWalmartField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'warehouse' => ( type => 'Select', );

    has_field 'walmart' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package CompanyWarehouseField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'company' => ( type => 'Select', );

    has_field 'warehouse' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}




