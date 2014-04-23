# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=RawRailLine --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::RawRailLine;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'RawRailLine' );



    has_field 'geom' => ( type => 'TextArea', );

    has_field 'old1' => ( type => 'Text', size => 4, );

    has_field 't3' => ( type => 'Text', size => 4, );

    has_field 't2' => ( type => 'Text', size => 4, );

    has_field 't1' => ( type => 'Text', size => 4, );

    has_field 'w2' => ( type => 'Text', size => 4, );

    has_field 'w1' => ( type => 'Text', size => 4, );

    has_field 'lineid' => ( type => 'Text', size => 4, );

    has_field 'sb' => ( type => 'Text', size => 4, );

    has_field 'jb' => ( type => 'Integer', );

    has_field 'ja' => ( type => 'Integer', );

    has_field 'lupdat' => ( type => 'Text', size => 1, );

    has_field 'lsrc' => ( type => 'Text', size => 1, );

    has_field 'densty' => ( type => 'Text', size => 1, );

    has_field 'signal' => ( type => 'Text', size => 1, );

    has_field 'milit' => ( type => 'Text', size => 1, );

    has_field 'pasngr' => ( type => 'Text', size => 1, );

    has_field 'status' => ( type => 'Text', size => 1, );

    has_field 'gauge' => ( type => 'Text', size => 1, );

    has_field 'grade' => ( type => 'Text', size => 1, );

    has_field 'trktyp' => ( type => 'Text', size => 1, );

    has_field 'mlc' => ( type => 'Text', size => 1, );

    has_field 'emlc' => ( type => 'Text', );

    has_field 'entrk' => ( type => 'Text', );

    has_field 'dirctn' => ( type => 'Text', size => 2, );

    has_field 'miles' => ( type => 'Text', );

    has_field 'qaux' => ( type => 'Text', size => 30, );

    has_field 'rtid' => ( type => 'Text', size => 13, );

    has_field 'alid' => ( type => 'Text', size => 8, );

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




