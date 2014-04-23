# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=SpatialRefSy --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::SpatialRefSy;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'SpatialRefSy' );



    has_field 'proj4text' => ( type => 'TextArea', );

    has_field 'srtext' => ( type => 'TextArea', );

    has_field 'auth_srid' => ( type => 'Integer', );

    has_field 'auth_name' => ( type => 'TextArea', );

    has_field 'srid' => ( type => 'Integer', required => 1, );

    has_field 'submit' => ( widget => 'Submit', );



    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}




