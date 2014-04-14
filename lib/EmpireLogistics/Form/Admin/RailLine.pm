# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=RailLine --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::RailLine;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'RailLine' );



    has_field 'geometry' => ( type => 'Text', );

    has_field 'trackage_rights3' => ( type => 'TextArea', );

    has_field 'trackage_rights2' => ( type => 'TextArea', );

    has_field 'trackage_rights1' => ( type => 'TextArea', );

    has_field 'owner2' => ( type => 'TextArea', );

    has_field 'owner1' => ( type => 'TextArea', );

    has_field 'subdivision' => ( type => 'TextArea', );

    has_field 'b_junction' => ( type => 'TextArea', );

    has_field 'a_junction' => ( type => 'TextArea', );

    has_field 'line_class' => ( type => 'TextArea', );

    has_field 'traffic_density' => ( type => 'TextArea', );

    has_field 'signal_system' => ( type => 'TextArea', );

    has_field 'military_subsystem' => ( type => 'TextArea', );

    has_field 'passenger' => ( type => 'TextArea', );

    has_field 'status' => ( type => 'TextArea', );

    has_field 'gauge' => ( type => 'TextArea', );

    has_field 'grade' => ( type => 'TextArea', );

    has_field 'track_type' => ( type => 'TextArea', );

    has_field 'direction' => ( type => 'TextArea', );

    has_field 'miles' => ( type => 'Text', );

    has_field 'route_id' => ( type => 'TextArea', );

    has_field 'link_id' => ( type => 'TextArea', );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'rail_line_work_stoppages' => ( type => '+RailLineWorkStoppageField', );

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

    package EmpireLogistics::Form::Admin::RailLineWorkStoppageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'rail_line' => ( type => 'Select', );

    has_field 'work_stoppage' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}




