package EmpireLogistics::Schema::Result::EditHistory;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("edit_history");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "edit_history_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.791565+00",
    is_nullable   => 0,
  },
  "object_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "object_type",
      list => [
        "address",
        "company",
        "company_address",
        "company_nlrb_decision",
        "company_osha_citation",
        "company_port",
        "company_rail_node",
        "company_warehouse",
        "edit_history",
        "edit_history_field",
        "labor_organization",
        "labor_organization_account_payable",
        "labor_organization_account_receivable",
        "labor_organization_address",
        "labor_organization_affiliation",
        "labor_organization_benefit_disbursement",
        "labor_organization_fixed_asset",
        "labor_organization_general_disbursement",
        "labor_organization_investment_asset",
        "labor_organization_investment_purchase",
        "labor_organization_loan_payable",
        "labor_organization_loan_receivable",
        "labor_organization_membership",
        "labor_organization_nlrb_decision",
        "labor_organization_officer_disbursement",
        "labor_organization_osha_citation",
        "labor_organization_other_asset",
        "labor_organization_other_liability",
        "labor_organization_other_receipt",
        "labor_organization_payee",
        "labor_organization_payee_address",
        "labor_organization_port",
        "labor_organization_rail_node",
        "labor_organization_sale_receipt",
        "labor_organization_total_asset",
        "labor_organization_total_disbursement",
        "labor_organization_total_liability",
        "labor_organization_total_receipt",
        "labor_organization_warehouse",
        "labor_organization_work_stoppage",
        "media",
        "nlrb_decision",
        "osha_citation",
        "port",
        "port_address",
        "port_depth_feet",
        "port_depth_meters",
        "port_drydock",
        "port_harbor_size",
        "port_harbor_type",
        "port_repair",
        "port_shelter",
        "port_tonnage",
        "port_vessel_size",
        "port_work_stoppage",
        "rail_density",
        "rail_interline",
        "rail_line",
        "rail_line_class",
        "rail_line_work_stoppage",
        "rail_military",
        "rail_node",
        "rail_node_work_stoppage",
        "rail_ownership",
        "rail_passenger",
        "rail_signal",
        "rail_status",
        "rail_subdivision",
        "rail_subdivision_state",
        "rail_track_gauge",
        "rail_track_grade",
        "rail_track_type",
        "state",
        "topology",
        "user",
        "walmart",
        "warehouse",
        "warehouse_address",
        "warehouse_type",
        "warehouse_walmart",
        "warehouse_work_stoppage",
        "work_stoppage",
      ],
    },
    is_nullable => 0,
  },
  "object",
  { data_type => "integer", is_nullable => 0 },
  "user",
  { data_type => "integer", is_nullable => 0 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "edit_history_fields",
  "EmpireLogistics::Schema::Result::EditHistoryField",
  { "foreign.edit_history" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);




__PACKAGE__->meta->make_immutable;
1;
