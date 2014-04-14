# Generated automatically with HTML::FormHandler::Generator::DBIC

# Using following commandline:

# form_generator.pl --rs_name=LaborOrganization --schema_name=EmpireLogistics::Schema --db_dsn=dbi:Pg:dbname=empireLogistics

{

    package EmpireLogistics::Form::Admin::LaborOrganization;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Model::DBIC';

    use namespace::autoclean;



    use DateTime;





    has '+item_class' => ( default => 'LaborOrganization' );



    has_field 'description' => ( type => 'TextArea', );

    has_field 'local_number' => ( type => 'TextArea', );

    has_field 'local_type' => ( type => 'TextArea', );

    has_field 'local_suffix' => ( type => 'TextArea', );

    has_field 'local_prefix' => ( type => 'TextArea', );

    has_field 'organization_type' => ( type => 'Text', required => 1, );

    has_field 'url' => ( type => 'TextArea', );

    has_field 'date_established' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'date_established.year';        has_field 'date_established.month';        has_field 'date_established.day';

    has_field 'abbreviation' => ( type => 'TextArea', );

    has_field 'usdol_filing_number' => ( type => 'Integer', );

    has_field 'name' => ( type => 'TextArea', );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization_officer_disbursements' => ( type => '+LaborOrganizationOfficerDisbursementField', );

    has_field 'labor_organization_loan_payables' => ( type => '+LaborOrganizationLoanPayableField', );

    has_field 'labor_organization_total_disbursements' => ( type => '+LaborOrganizationTotalDisbursementField', );

    has_field 'labor_organization_loan_receivables' => ( type => '+LaborOrganizationLoanReceivableField', );

    has_field 'labor_organization_other_receipts' => ( type => '+LaborOrganizationOtherReceiptField', );

    has_field 'labor_organization_investment_purchases' => ( type => '+LaborOrganizationInvestmentPurchaseField', );

    has_field 'labor_organization_benefit_disbursements' => ( type => '+LaborOrganizationBenefitDisbursementField', );

    has_field 'labor_organization_warehouses' => ( type => '+LaborOrganizationWarehouseField', );

    has_field 'labor_organization_nlrb_decisions' => ( type => '+LaborOrganizationNlrbDecisionField', );

    has_field 'labor_organization_total_liabilities' => ( type => '+LaborOrganizationTotalLiabilityField', );

    has_field 'labor_organization_investment_assets' => ( type => '+LaborOrganizationInvestmentAssetField', );

    has_field 'labor_organization_rail_nodes' => ( type => '+LaborOrganizationRailNodeField', );

    has_field 'labor_organization_fixed_assets' => ( type => '+LaborOrganizationFixedAssetField', );

    has_field 'labor_organization_osha_citations' => ( type => '+LaborOrganizationOshaCitationField', );

    has_field 'labor_organization_total_assets' => ( type => '+LaborOrganizationTotalAssetField', );

    has_field 'labor_organization_total_receipts' => ( type => '+LaborOrganizationTotalReceiptField', );

    has_field 'labor_organization_account_receivables' => ( type => '+LaborOrganizationAccountReceivableField', );

    has_field 'labor_organization_account_payables' => ( type => '+LaborOrganizationAccountPayableField', );

    has_field 'labor_organization_other_assets' => ( type => '+LaborOrganizationOtherAssetField', );

    has_field 'labor_organization_other_liabilities' => ( type => '+LaborOrganizationOtherLiabilityField', );

    has_field 'labor_organization_general_disbursements' => ( type => '+LaborOrganizationGeneralDisbursementField', );

    has_field 'labor_organization_affiliation_parents' => ( type => '+LaborOrganizationAffiliationField', );

    has_field 'labor_organization_sale_receipts' => ( type => '+LaborOrganizationSaleReceiptField', );

    has_field 'labor_organization_ports' => ( type => '+LaborOrganizationPortField', );

    has_field 'labor_organization_memberships' => ( type => '+LaborOrganizationMembershipField', );

    has_field 'labor_organization_work_stoppages' => ( type => '+LaborOrganizationWorkStoppageField', );

    has_field 'labor_organization_addresses' => ( type => '+LaborOrganizationAddressField', );

    has_field 'labor_organization_payees' => ( type => '+LaborOrganizationPayeeField', );

    has_field 'labor_organization_affiliation_children' => ( type => '+LaborOrganizationAffiliationField', );

    has_field 'edits' => ( type => '+EditHistoryField', );

    has_field 'submit' => ( widget => 'Submit', );



    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationLoanReceivableField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'terms' => ( type => 'TextArea', );

    has_field 'security' => ( type => 'TextArea', );

    has_field 'purpose' => ( type => 'TextArea', );

    has_field 'outstanding_start_amount' => ( type => 'Integer', );

    has_field 'outstanding_end_amount' => ( type => 'Integer', );

    has_field 'non_cash_repayments' => ( type => 'Integer', );

    has_field 'new_loan_amount' => ( type => 'Integer', );

    has_field 'name' => ( type => 'TextArea', );

    has_field 'loan_type' => ( type => 'Text', );

    has_field 'cash_repayments' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationWorkStoppageField;

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

    package EmpireLogistics::Form::Admin::LaborOrganizationOtherReceiptField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'purpose' => ( type => 'TextArea', );

    has_field 'receipt_date' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'receipt_date.year';        has_field 'receipt_date.month';        has_field 'receipt_date.day';

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'payee' => ( type => 'Select', );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationAccountReceivableField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'total' => ( type => 'Integer', );

    has_field 'past_due_180' => ( type => 'Integer', );

    has_field 'past_due_90' => ( type => 'Integer', );

    has_field 'name' => ( type => 'TextArea', );

    has_field 'liquidated' => ( type => 'Integer', );

    has_field 'account_type' => ( type => 'Text', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationOfficerDisbursementField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'total' => ( type => 'Integer', );

    has_field 'representation_percent' => ( type => 'Integer', );

    has_field 'political_percent' => ( type => 'Integer', );

    has_field 'gross_salary' => ( type => 'Integer', );

    has_field 'general_overhead_percent' => ( type => 'Integer', );

    has_field 'contributions_percent' => ( type => 'Integer', );

    has_field 'administration_percent' => ( type => 'Integer', );

    has_field 'title' => ( type => 'TextArea', );

    has_field 'last_name' => ( type => 'TextArea', );

    has_field 'middle_name' => ( type => 'TextArea', );

    has_field 'first_name' => ( type => 'TextArea', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationOtherAssetField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'value' => ( type => 'Integer', );

    has_field 'description' => ( type => 'TextArea', );

    has_field 'book_value' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationTotalLiabilityField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'total_start' => ( type => 'Integer', );

    has_field 'other_liabilities_start' => ( type => 'Integer', );

    has_field 'other_liabilities_end' => ( type => 'Integer', );

    has_field 'mortgages_payable_start' => ( type => 'Integer', );

    has_field 'mortgages_payable_end' => ( type => 'Integer', );

    has_field 'loans_payable_start' => ( type => 'Integer', );

    has_field 'loans_payable_end' => ( type => 'Integer', );

    has_field 'accounts_payable_start' => ( type => 'Integer', );

    has_field 'accounts_payable_end' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

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

    package EmpireLogistics::Form::Admin::LaborOrganizationInvestmentPurchaseField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'investment_type' => ( type => 'Text', );

    has_field 'description' => ( type => 'TextArea', );

    has_field 'cost' => ( type => 'Integer', );

    has_field 'cash_paid' => ( type => 'Integer', );

    has_field 'book_value' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationRailNodeField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'rail_node' => ( type => 'Select', );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationGeneralDisbursementField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'purpose' => ( type => 'TextArea', );

    has_field 'disbursement_type' => ( type => 'Text', );

    has_field 'disbursement_date' => ( 

            type => 'Compound',

            apply => [

                {

                    transform => sub{ DateTime->new( $_[0] ) },

                    message => "Not a valid DateTime",

                }

            ],

        );

        has_field 'disbursement_date.year';        has_field 'disbursement_date.month';        has_field 'disbursement_date.day';

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'payee' => ( type => 'Select', );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationLoanPayableField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'source' => ( type => 'TextArea', );

    has_field 'non_cash_repayment' => ( type => 'Integer', );

    has_field 'loans_owed_start' => ( type => 'Integer', );

    has_field 'loans_owed_end' => ( type => 'Integer', );

    has_field 'loans_obtained' => ( type => 'Integer', );

    has_field 'cash_repayment' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationSaleReceiptField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'gross_sales_price' => ( type => 'Integer', );

    has_field 'description' => ( type => 'TextArea', );

    has_field 'cost' => ( type => 'Integer', );

    has_field 'book_value' => ( type => 'Integer', );

    has_field 'amount_received' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationTotalReceiptField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'tax' => ( type => 'Integer', );

    has_field 'rents' => ( type => 'Integer', );

    has_field 'other_receipts' => ( type => 'Integer', );

    has_field 'office_supplies' => ( type => 'Integer', );

    has_field 'members' => ( type => 'Integer', );

    has_field 'loans_taken' => ( type => 'Integer', );

    has_field 'loans_made' => ( type => 'Integer', );

    has_field 'investments' => ( type => 'Integer', );

    has_field 'interest' => ( type => 'Integer', );

    has_field 'fees' => ( type => 'Integer', );

    has_field 'dues' => ( type => 'Integer', );

    has_field 'dividends' => ( type => 'Integer', );

    has_field 'all_other_receipts' => ( type => 'Integer', );

    has_field 'affiliates' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationOshaCitationField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'osha_citation' => ( type => 'Select', );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationTotalAssetField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



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

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationPayeeField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'usdol_payee_id' => ( type => 'Integer', );

    has_field 'amount' => ( type => 'Integer', );

    has_field 'payment_type' => ( type => 'TextArea', );

    has_field 'payee_type' => ( type => 'Text', );

    has_field 'name' => ( type => 'TextArea', required => 1, );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationAccountPayableField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'total' => ( type => 'Integer', );

    has_field 'past_due_180' => ( type => 'Integer', );

    has_field 'past_due_90' => ( type => 'Integer', );

    has_field 'name' => ( type => 'TextArea', );

    has_field 'liquidated' => ( type => 'Integer', );

    has_field 'account_type' => ( type => 'Text', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationWarehouseField;

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

    package EmpireLogistics::Form::Admin::LaborOrganizationNlrbDecisionField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    has_field 'nlrb_decision' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationMembershipField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'members' => ( type => 'Integer', required => 1, );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationInvestmentAssetField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'name' => ( type => 'TextArea', );

    has_field 'investment_type' => ( type => 'Text', );

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationAddressField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    has_field 'address' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationFixedAssetField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'value' => ( type => 'Integer', );

    has_field 'description' => ( type => 'TextArea', );

    has_field 'depreciation' => ( type => 'Integer', );

    has_field 'cost_basis' => ( type => 'Integer', );

    has_field 'book_value' => ( type => 'Integer', );

    has_field 'asset_type' => ( type => 'Text', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationTotalDisbursementField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'withheld_not_disbursed' => ( type => 'Integer', );

    has_field 'withheld' => ( type => 'Integer', );

    has_field 'union_administration' => ( type => 'Integer', );

    has_field 'taxes' => ( type => 'Integer', );

    has_field 'strike_benefits' => ( type => 'Integer', );

    has_field 'representation' => ( type => 'Integer', );

    has_field 'professional_services' => ( type => 'Integer', );

    has_field 'political' => ( type => 'Integer', );

    has_field 'per_capita_tax' => ( type => 'Integer', );

    has_field 'other_union_administration' => ( type => 'Integer', );

    has_field 'other_representation' => ( type => 'Integer', );

    has_field 'other_political' => ( type => 'Integer', );

    has_field 'other_general_overhead' => ( type => 'Integer', );

    has_field 'other_contributions' => ( type => 'Integer', );

    has_field 'other' => ( type => 'Integer', );

    has_field 'office_supplies' => ( type => 'Integer', );

    has_field 'officers_total' => ( type => 'Integer', );

    has_field 'officer_salaries' => ( type => 'Integer', );

    has_field 'officer_administration' => ( type => 'Integer', );

    has_field 'members' => ( type => 'Integer', );

    has_field 'loans_paid' => ( type => 'Integer', );

    has_field 'loans_made' => ( type => 'Integer', );

    has_field 'investments' => ( type => 'Integer', );

    has_field 'general_overhead' => ( type => 'Integer', );

    has_field 'fees' => ( type => 'Integer', );

    has_field 'employees_total' => ( type => 'Integer', );

    has_field 'employee_salaries' => ( type => 'Integer', );

    has_field 'education' => ( type => 'Integer', );

    has_field 'contributions' => ( type => 'Integer', );

    has_field 'benefits' => ( type => 'Integer', );

    has_field 'affiliates' => ( type => 'Integer', );

    has_field 'administration' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationPortField;

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





{

    package EmpireLogistics::Form::Admin::LaborOrganizationAffiliationField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'year' => ( type => 'Integer', );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'parent' => ( type => 'Select', );

    has_field 'child' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationOtherLiabilityField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'description' => ( type => 'TextArea', );

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}





{

    package EmpireLogistics::Form::Admin::LaborOrganizationBenefitDisbursementField;

    use HTML::FormHandler::Moose;

    extends 'HTML::FormHandler::Field::Compound';

    use namespace::autoclean;



    has_field 'paid_to' => ( type => 'TextArea', );

    has_field 'description' => ( type => 'TextArea', );

    has_field 'amount' => ( type => 'Integer', );

    has_field 'year' => ( type => 'Integer', required => 1, );

    has_field 'delete_time' => ( type => 'Text', );

    has_field 'update_time' => ( type => 'Text', required => 1, );

    has_field 'create_time' => ( type => 'Text', required => 1, );

    has_field 'labor_organization' => ( type => 'Select', );

    

    __PACKAGE__->meta->make_immutable;

    no HTML::FormHandler::Moose;

}




