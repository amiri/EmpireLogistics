# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=RawPort --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::RawPort;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'RawPort' );



    has_field 'geom' => ( type => 'TextArea', );

    has_field 'railway' => ( type => 'TextArea', );

    has_field 'drydock' => ( type => 'TextArea', );

    has_field 'repaircode' => ( type => 'TextArea', );

    has_field 'eng_supply' => ( type => 'TextArea', );

    has_field 'decksupply' => ( type => 'TextArea', );

    has_field 'diesel' => ( type => 'TextArea', );

    has_field 'fuel_oil' => ( type => 'TextArea', );

    has_field 'water' => ( type => 'TextArea', );

    has_field 'provisions' => ( type => 'TextArea', );

    has_field 'elecrepair' => ( type => 'TextArea', );

    has_field 'nav_equip' => ( type => 'TextArea', );

    has_field 'serv_steam' => ( type => 'TextArea', );

    has_field 'electrical' => ( type => 'TextArea', );

    has_field 'longshore' => ( type => 'TextArea', );

    has_field 'lift_0_24' => ( type => 'TextArea', );

    has_field 'lift_25_49' => ( type => 'TextArea', );

    has_field 'lift50_100' => ( type => 'TextArea', );

    has_field 'lift_100_' => ( type => 'TextArea', );

    has_field 'cranefloat' => ( type => 'TextArea', );

    has_field 'cranemobil' => ( type => 'TextArea', );

    has_field 'cranefixed' => ( type => 'TextArea', );

    has_field 'drtyballst' => ( type => 'TextArea', );

    has_field 'degauss' => ( type => 'TextArea', );

    has_field 'garbage' => ( type => 'TextArea', );

    has_field 'med_facil' => ( type => 'TextArea', );

    has_field 'caricemoor' => ( type => 'TextArea', );

    has_field 'carbchmoor' => ( type => 'TextArea', );

    has_field 'cargmdmoor' => ( type => 'TextArea', );

    has_field 'cargo_anch' => ( type => 'TextArea', );

    has_field 'cargowharf' => ( type => 'TextArea', );

    has_field 'comm_rail' => ( type => 'TextArea', );

    has_field 'comm_air' => ( type => 'TextArea', );

    has_field 'comm_vhf' => ( type => 'TextArea', );

    has_field 'comm_radio' => ( type => 'TextArea', );

    has_field 'comm_fax' => ( type => 'TextArea', );

    has_field 'comm_phone' => ( type => 'TextArea', );

    has_field 'quar_other' => ( type => 'TextArea', );

    has_field 'sscc_cert' => ( type => 'TextArea', );

    has_field 'pratique' => ( type => 'TextArea', );

    has_field 'tug_assist' => ( type => 'TextArea', );

    has_field 'tugsalvage' => ( type => 'TextArea', );

    has_field 'pilotadvsd' => ( type => 'TextArea', );

    has_field 'loc_assist' => ( type => 'TextArea', );

    has_field 'pilotavail' => ( type => 'TextArea', );

    has_field 'pilot_reqd' => ( type => 'TextArea', );

    has_field 'etamessage' => ( type => 'TextArea', );

    has_field 'us_rep' => ( type => 'TextArea', );

    has_field 'portofentr' => ( type => 'TextArea', );

    has_field 'turn_basin' => ( type => 'TextArea', );

    has_field 'holdground' => ( type => 'TextArea', );

    has_field 'max_vessel' => ( type => 'TextArea', );

    has_field 'tide_range' => ( type => 'Text', );

    has_field 'oil_depth' => ( type => 'TextArea', );

    has_field 'cargodepth' => ( type => 'TextArea', );

    has_field 'anch_depth' => ( type => 'TextArea', );

    has_field 'chan_depth' => ( type => 'TextArea', );

    has_field 'overhd_lim' => ( type => 'TextArea', );

    has_field 'entryother' => ( type => 'TextArea', );

    has_field 'entry_ice' => ( type => 'TextArea', );

    has_field 'entryswell' => ( type => 'TextArea', );

    has_field 'entry_tide' => ( type => 'TextArea', );

    has_field 'shelter' => ( type => 'TextArea', );

    has_field 'harbortype' => ( type => 'TextArea', );

    has_field 'harborsize' => ( type => 'TextArea', );

    has_field 'chart' => ( type => 'TextArea', );

    has_field 'pub' => ( type => 'TextArea', );

    has_field 'long_hemi' => ( type => 'TextArea', );

    has_field 'long_min' => ( type => 'Text', );

    has_field 'long_deg' => ( type => 'Text', );

    has_field 'lat_hemi' => ( type => 'TextArea', );

    has_field 'lat_min' => ( type => 'Text', );

    has_field 'lat_deg' => ( type => 'Text', );

    has_field 'longitude' => ( type => 'Text', );

    has_field 'latitude' => ( type => 'Text', );

    has_field 'country' => ( type => 'TextArea', );

    has_field 'port_name' => ( type => 'TextArea', );

    has_field 'region_no' => ( type => 'Text', );

    has_field 'index_no' => ( type => 'Text', );

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




