# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=Port --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::Port;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;





    has '+item_class' => ( default => 'Port' );



    has_field 'geometry' => ( type => 'TextArea', );

    has_field 'longitude' => ( type => 'Text', );

    has_field 'latitude' => ( type => 'Text', );

    has_field 'railway' => ( type => 'TextArea', );

    has_field 'drydock' => ( type => 'TextArea', );

    has_field 'repairs' => ( type => 'TextArea', );

    has_field 'supplies_engine' => ( type => 'Text', );

    has_field 'supplies_deck' => ( type => 'Text', );

    has_field 'supplies_diesel_oil' => ( type => 'Text', );

    has_field 'supplies_fuel_oil' => ( type => 'Text', );

    has_field 'supplies_water' => ( type => 'Text', );

    has_field 'supplies_provisions' => ( type => 'Text', );

    has_field 'electrical_repair_services' => ( type => 'Text', );

    has_field 'navigation_equipment_services' => ( type => 'Text', );

    has_field 'steam_services' => ( type => 'Text', );

    has_field 'electrical_services' => ( type => 'Text', );

    has_field 'longshore_services' => ( type => 'Text', );

    has_field 'cranes_lift_0_24_tons' => ( type => 'Text', );

    has_field 'cranes_lift_25_49_tons' => ( type => 'Text', );

    has_field 'cranes_lift_50_100_tons' => ( type => 'Text', );

    has_field 'cranes_lift_100_tons' => ( type => 'Text', );

    has_field 'floating_cranes' => ( type => 'Text', );

    has_field 'mobile_cranes' => ( type => 'Text', );

    has_field 'fixed_cranes' => ( type => 'Text', );

    has_field 'dirty_ballast' => ( type => 'Text', );

    has_field 'degaussing_available' => ( type => 'Text', );

    has_field 'garbage_disposal' => ( type => 'Text', );

    has_field 'medical_facilities' => ( type => 'Text', );

    has_field 'load_offload_ice_moor' => ( type => 'Text', );

    has_field 'load_offload_beach_moor' => ( type => 'Text', );

    has_field 'load_offload_medium_moor' => ( type => 'Text', );

    has_field 'load_offload_anchor' => ( type => 'Text', );

    has_field 'load_offload_wharf' => ( type => 'Text', );

    has_field 'comm_rail' => ( type => 'Text', );

    has_field 'comm_air' => ( type => 'Text', );

    has_field 'comm_vhf' => ( type => 'Text', );

    has_field 'comm_radio' => ( type => 'Text', );

    has_field 'comm_fax' => ( type => 'Text', );

    has_field 'comm_phone' => ( type => 'Text', );

    has_field 'quarantine_other_required' => ( type => 'Text', );

    has_field 'quarantine_sscc_certification_required' => ( type => 'Text', );

    has_field 'quarantine_pratique_required' => ( type => 'Text', );

    has_field 'tugs_can_assist' => ( type => 'Text', );

    has_field 'tugs_can_salvage' => ( type => 'Text', );

    has_field 'pilotage_advisable' => ( type => 'Text', );

    has_field 'pilotage_local_assistance' => ( type => 'Text', );

    has_field 'pilotage_available' => ( type => 'Text', );

    has_field 'pilotage_required' => ( type => 'Text', );

    has_field 'eta_message' => ( type => 'Text', );

    has_field 'us_representative' => ( type => 'Text', );

    has_field 'first_port_of_entry' => ( type => 'Text', );

    has_field 'turning_basin' => ( type => 'Text', );

    has_field 'good_holding_ground' => ( type => 'Text', );

    has_field 'max_vessel_size' => ( type => 'TextArea', );

    has_field 'tide_range' => ( type => 'Integer', );

    has_field 'oil_terminal_depth' => ( type => 'TextArea', );

    has_field 'cargo_pier_depth' => ( type => 'TextArea', );

    has_field 'anchor_depth' => ( type => 'TextArea', );

    has_field 'channel_depth' => ( type => 'TextArea', );

    has_field 'overhead_limits' => ( type => 'Text', );

    has_field 'entry_other_restriction' => ( type => 'Text', );

    has_field 'entry_ice_restriction' => ( type => 'Text', );

    has_field 'entry_swell_restriction' => ( type => 'Text', );

    has_field 'entry_tide_restriction' => ( type => 'Text', );

    has_field 'shelter' => ( type => 'TextArea', );

    has_field 'harbor_type' => ( type => 'TextArea', );

    has_field 'harbor_size' => ( type => 'TextArea', );

    has_field 'country' => ( type => 'TextArea', );

    has_field 'port_name' => ( type => 'TextArea', );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'port_tonnages' => ( type => '+PortTonnageField', );

    has_field 'labor_organization_ports' => ( type => '+LaborOrganizationPortField', );

    has_field 'port_addresses' => ( type => '+PortAddressField', );

    has_field 'company_ports' => ( type => '+CompanyPortField', );

    has_field 'edits' => ( type => '+EditHistoryField', );

    has_field 'port_work_stoppages' => ( type => '+PortWorkStoppageField', );

    has_field 'submit' => ( widget => 'Submit', );



    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::PortTonnageField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'total_tonnage' => ( type => 'Integer', );

    has_field 'export_tonnage' => ( type => 'Integer', );

    has_field 'import_tonnage' => ( type => 'Integer', );

    has_field 'foreign_tonnage' => ( type => 'Integer', );

    has_field 'domestic_tonnage' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'port' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::PortAddressField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'address' => ( type => 'Select', );

    has_field 'port' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package CompanyPortField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'company' => ( type => 'Select', );

    has_field 'port' => ( type => 'Select', );

    

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

    package EmpireLogistics::Form::Admin::PortWorkStoppageField;

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

    package LaborOrganizationPortField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'port' => ( type => 'Select', );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}




