# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=WorkStoppage --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::WorkStoppage;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;



    use DateTime;





    has '+item_class' => ( default => 'WorkStoppage' );



    has_field 'description' => ( type => 'TextArea', );

    has_field 'end_date' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'end_date.year';        has_field 'end_date.month';        has_field 'end_date.day';

    has_field 'start_date' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'start_date.year';        has_field 'start_date.month';        has_field 'start_date.day';

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'edits' => ( type => '+EditHistoryField', );

    has_field 'port_work_stoppages' => ( type => '+PortWorkStoppageField', );

    has_field 'labor_organization_work_stoppages' => ( type => '+LaborOrganizationWorkStoppageField', );

    has_field 'rail_node_work_stoppages' => ( type => '+RailNodeWorkStoppageField', );

    has_field 'warehouse_work_stoppages' => ( type => '+WarehouseWorkStoppageField', );

    has_field 'rail_line_work_stoppages' => ( type => '+RailLineWorkStoppageField', );

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

    package RailNodeWorkStoppageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'work_stoppage' => ( type => 'Select', );

    has_field 'rail_node' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package PortWorkStoppageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'work_stoppage' => ( type => 'Select', );

    has_field 'port' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package LaborOrganizationWorkStoppageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'work_stoppage' => ( type => 'Select', );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package WarehouseWorkStoppageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'warehouse' => ( type => 'Select', );

    has_field 'work_stoppage' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package RailLineWorkStoppageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'work_stoppage' => ( type => 'Select', );

    has_field 'rail_line' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}




