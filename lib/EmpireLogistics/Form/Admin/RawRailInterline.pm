# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=RawRailInterline --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::RawRailInterline;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'RawRailInterline' );



    has_field 'namea' => ( type => 'TextArea', );

    has_field 'alias' => ( type => 'TextArea', );

    has_field 'wa' => ( type => 'TextArea', );

    has_field 'wtrm' => ( type => 'TextArea', );

    has_field 'id' => ( type => 'TextArea', );

    has_field 'impedance' => ( type => 'TextArea', );

    has_field 'iidq' => ( type => 'TextArea', );

    has_field 'iidname' => ( type => 'TextArea', );

    has_field 'nameb' => ( type => 'TextArea', );

    has_field 'ijb' => ( type => 'TextArea', );

    has_field 'name' => ( type => 'TextArea', );

    has_field 'ityp' => ( type => 'TextArea', );

    has_field 'wb' => ( type => 'TextArea', );

    has_field 'ija' => ( type => 'TextArea', );

    has_field 'wkb_geometry' => ( type => 'TextArea', );

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




