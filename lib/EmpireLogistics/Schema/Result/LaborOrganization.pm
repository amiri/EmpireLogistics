package EmpireLogistics::Schema::Result::LaborOrganization;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("labor_organization");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "labor_organization_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "usdol_filing_number",
  { data_type => "integer", is_nullable => 1 },
  "abbreviation",
  { data_type => "text", is_nullable => 1 },
  "date_established",
  { data_type => "date", is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "organization_type",
  {
    data_type => "integer",
    is_nullable => 0,
  },
  "local_prefix",
  { data_type => "text", is_nullable => 1 },
  "local_suffix",
  { data_type => "text", is_nullable => 1 },
  "local_type",
  { data_type => "text", is_nullable => 1 },
  "local_number",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "labor_organization_name_usdol_filing_number_abbreviation_or_key",
  [
    "name",
    "usdol_filing_number",
    "abbreviation",
    "organization_type",
    "local_prefix",
    "local_suffix",
    "local_type",
    "local_number",
    "description",
  ],
);
__PACKAGE__->belongs_to(
    "organization_type" => "EmpireLogistics::Schema::Result::LaborOrganizationType",
    {"foreign.id" => "self.organization_type"},
    {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_addresses",
  "EmpireLogistics::Schema::Result::LaborOrganizationAddress",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_affiliation_children",
  "EmpireLogistics::Schema::Result::LaborOrganizationAffiliation",
  { "foreign.parent" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_affiliation_parents",
  "EmpireLogistics::Schema::Result::LaborOrganizationAffiliation",
  { "foreign.child" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->many_to_many(
    'affiliates' => 'labor_organization_affiliation_children', 'child',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'affiliations' => 'labor_organization_affiliation_parents', 'parent',
    {where => {'me.delete_time' => undef}},
);
# Accounts
__PACKAGE__->has_many(
  "labor_organization_account_payables",
  "EmpireLogistics::Schema::Result::LaborOrganizationAccountPayable",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_account_receivables",
  "EmpireLogistics::Schema::Result::LaborOrganizationAccountReceivable",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

# Assets
__PACKAGE__->has_many(
  "labor_organization_investment_assets",
  "EmpireLogistics::Schema::Result::LaborOrganizationInvestmentAsset",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_fixed_assets",
  "EmpireLogistics::Schema::Result::LaborOrganizationFixedAsset",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_other_assets",
  "EmpireLogistics::Schema::Result::LaborOrganizationOtherAsset",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_total_assets",
  "EmpireLogistics::Schema::Result::LaborOrganizationTotalAsset",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

# Disbursements
__PACKAGE__->has_many(
  "labor_organization_investment_purchases",
  "EmpireLogistics::Schema::Result::LaborOrganizationInvestmentPurchase",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_benefit_disbursements",
  "EmpireLogistics::Schema::Result::LaborOrganizationBenefitDisbursement",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_general_disbursements",
  "EmpireLogistics::Schema::Result::LaborOrganizationGeneralDisbursement",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_officer_disbursements",
  "EmpireLogistics::Schema::Result::LaborOrganizationOfficerDisbursement",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_total_disbursements",
  "EmpireLogistics::Schema::Result::LaborOrganizationTotalDisbursement",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);


# Loans
__PACKAGE__->has_many(
  "labor_organization_loan_payables",
  "EmpireLogistics::Schema::Result::LaborOrganizationLoanPayable",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_loan_receivables",
  "EmpireLogistics::Schema::Result::LaborOrganizationLoanReceivable",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);


# Liabilities
__PACKAGE__->has_many(
  "labor_organization_other_liabilities",
  "EmpireLogistics::Schema::Result::LaborOrganizationOtherLiability",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_total_liabilities",
  "EmpireLogistics::Schema::Result::LaborOrganizationTotalLiability",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

# Memberships
__PACKAGE__->has_many(
  "labor_organization_memberships",
  "EmpireLogistics::Schema::Result::LaborOrganizationMembership",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

# Receipts
__PACKAGE__->has_many(
  "labor_organization_sale_receipts",
  "EmpireLogistics::Schema::Result::LaborOrganizationSaleReceipt",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_total_receipts",
  "EmpireLogistics::Schema::Result::LaborOrganizationTotalReceipt",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_other_receipts",
  "EmpireLogistics::Schema::Result::LaborOrganizationOtherReceipt",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);




# Decisions
__PACKAGE__->has_many(
  "labor_organization_osha_citations",
  "EmpireLogistics::Schema::Result::LaborOrganizationOshaCitation",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_nlrb_decisions",
  "EmpireLogistics::Schema::Result::LaborOrganizationNlrbDecision",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);





# Relationships
__PACKAGE__->has_many(
  "labor_organization_payees",
  "EmpireLogistics::Schema::Result::LaborOrganizationPayee",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_ports",
  "EmpireLogistics::Schema::Result::LaborOrganizationPort",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_rail_nodes",
  "EmpireLogistics::Schema::Result::LaborOrganizationRailNode",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_rail_lines",
  "EmpireLogistics::Schema::Result::LaborOrganizationRailLine",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_warehouses",
  "EmpireLogistics::Schema::Result::LaborOrganizationWarehouse",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_work_stoppages",
  "EmpireLogistics::Schema::Result::LaborOrganizationWorkStoppage",
  { "foreign.labor_organization" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);



__PACKAGE__->many_to_many(
    'addresses' => 'labor_organization_addresses', 'address',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'ports' => 'labor_organization_ports', 'port',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'rail_nodes' => 'labor_organization_rail_nodes', 'rail_node',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'rail_lines' => 'labor_organization_rail_lines', 'rail_line',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'warehouses' => 'labor_organization_warehouses', 'warehouse',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'work_stoppages' => 'labor_organization_work_stoppages', 'work_stoppage',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'osha_citations' => 'labor_organization_osha_citations', 'osha_citation',
    {where => {'me.delete_time' => undef}},
);
__PACKAGE__->many_to_many(
    'nlrb_decisions' => 'labor_organization_nlrb_decisions', 'nlrb_decision',
    {where => {'me.delete_time' => undef}},
);

__PACKAGE__->belongs_to(
    "object_type" =>
    "EmpireLogistics::Schema::Result::ObjectType",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.name " => { -ident => "$args->{self_resultsource}.name" },
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.name" => $args->{self_resultsource}->name,
            },
        );
    },
);

__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

sub full_name {
    my $self = shift;
    my $name = $self->name;
    $name .= ' (' . $self->organization_type->name . ') '
        unless $self->organization_type->name eq 'local';
    $name .= ' ' . $self->local_prefix  if $self->local_prefix;
    $name .= ' ' . $self->local_type    if $self->local_type;
    $name .= ' #' . $self->local_number if $self->local_number;
    $name .= ' ' . $self->local_suffix  if $self->local_suffix;
    return $name;
}

around 'add_to_addresses' => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_);
};

__PACKAGE__->meta->make_immutable;
1;
