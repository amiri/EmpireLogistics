# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=RasterColumn --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::RasterColumn;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'RasterColumn' );



    has_field 'extent' => ( type => 'Text', );

    has_field 'out_db' => ( type => 'Text', );

    has_field 'nodata_values' => ( type => 'Text', );

    has_field 'pixel_types' => ( type => 'Text', );

    has_field 'num_bands' => ( type => 'Integer', );

    has_field 'regular_blocking' => ( type => 'Text', );

    has_field 'same_alignment' => ( type => 'Text', );

    has_field 'blocksize_y' => ( type => 'Integer', );

    has_field 'blocksize_x' => ( type => 'Integer', );

    has_field 'scale_y' => ( type => 'Text', );

    has_field 'scale_x' => ( type => 'Text', );

    has_field 'srid' => ( type => 'Integer', );

    has_field 'r_raster_column' => ( type => 'TextArea', );

    has_field 'r_table_name' => ( type => 'TextArea', );

    has_field 'r_table_schema' => ( type => 'TextArea', );

    has_field 'r_table_catalog' => ( type => 'TextArea', );

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




