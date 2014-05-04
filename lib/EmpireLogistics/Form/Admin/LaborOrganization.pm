package EmpireLogistics::Form::Admin::LaborOrganization;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'Printable');
use MooseX::Types::URI qw/Uri/;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'labor-organization-form');
has '+item_class' => (default => 'WorkStoppage');
has 'js_files'    => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        ['/js/admin/labor-organization.js',];
    },
);
has 'address_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'labor_organization_addresses',
);
has 'account_payable_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'labor_organization_account_payables',
);
has 'account_receivable_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'labor_organization_account_receivables',
);
has 'fixed_asset_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'labor_organization_fixed_assets',
);
has 'investment_asset_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'labor_organization_investment_assets',
);
has 'other_asset_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'labor_organization_other_assets',
);
has 'total_asset_relation' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'labor_organization_other_assets',
);

sub build_render_list {
    return [
        'metadata_block',
        'basic_block',
        'local_block',
        'affiliations_block',
        'address_block',
        'relations_block',
        'financials_block',
        'submit',
    ];
}

has_block 'metadata_block' => (
    tag         => 'div',
    label       => 'Metadata',
    render_list => [
        'id',
        'create_time',
        'update_time',
        'delete_time',
    ],
);
has_field 'id' => (
    type     => 'Integer',
    disabled => 1,
    readonly => 1,
    label    => 'Labor Organization ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_delete_time,
);

has_block 'basic_block' => (
    tag         => 'div',
    label       => 'Basic Information',
    render_list => [
        'name',
        'usdol_filing_number',
        'abbreviation',
        'date_established',
        'url',
        'organization_type',
        'description',
    ],
);

has_field 'name' => (type => 'Text', required => 1,);
has_field 'abbreviation' => (type => 'Text',);
has_field 'date_established' => (
    type            => 'Date',
    label           => 'Date Established',
    html5_type_attr => 'date',
);
has_field 'url' => (
    type            => 'Text',
    label           => 'URL',
    html5_type_attr => 'url',
    apply           => [Uri],
);
has_field 'description'         => (type => 'TextArea');
has_field 'usdol_filing_number' => (type => 'Text',);
has_field 'organization_type'   => (type => '+LaborOrganizationType',);

has_block 'local_block' => (
    tag         => 'div',
    label       => 'Local Information',
    render_list => [
        'local_type',
        'local_prefix',
        'local_number',
        'local_suffix'
    ],
);

has_field 'local_type'   => (type => 'Text',);
has_field 'local_prefix' => (type => 'Text',);
has_field 'local_number' => (type => 'Text',);
has_field 'local_suffix' => (type => 'Text',);

has_block 'address_block' => (
    tag           => 'div',
    render_list   => ['labor_organization_addresses', 'add_address'],
    label         => 'Yearly Addresses',
    wrapper_class => 'addresses',
);
has_field 'labor_organization_addresses' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 0,
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Simple',
        tags           => {wrapper_tag => 'div', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Simple',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'labor_organization_addresses.contains' =>
    (type => '+LaborOrganizationAddress',);

has_field 'add_address' => (
    type          => 'AddElement',
    repeatable    => 'labor_organization_addresses',
    value         => 'Add another address',
    element_class => ['btn btn-info'],
);

has_block 'affiliations_block' => (
    tag         => 'div',
    label       => 'Affiliates and Affiliations',
    render_list => [
        'affiliates',
        'affiliations',
    ],
);

has_field 'affiliates' => (
    type         => '+LaborOrganization',
    id           => 'affiliates',
    label        => 'Affiliated Labor Organizations',
    element_attr => {
        'data-placeholder' =>
            'Enter Labor Organizations Affiliated to This One'
    },
);
has_field 'affiliations' => (
    type         => '+LaborOrganization',
    id           => 'affiliations',
    label        => 'Parent Labor Organizations',
    element_attr => {
        'data-placeholder' =>
            'Enter Labor Organizations to Which This One is Affiliated'
    },
);

has_block 'relations_block' => (
    tag         => 'div',
    label       => 'Relationships',
    render_list => [
        'ports',
        'rail_nodes',
        'warehouses',
        'work_stoppages',
    ],
);

has_block 'financials_block' => (
    tag         => 'div',
    label       => 'Financial Information',
    render_list => [
        'accounts_block',
        'assets_block',
        'investment_block',
        'loans_block',
        'disbursements_block',
        'liabilities_block',
        'receipts_block',
        'payees_block',
    ],
);

has_block 'accounts_block' => (
    tag         => 'div',
    label       => 'Accounts',
    render_list => [
        'labor_organization_account_payables',
        'add_labor_organization_account_payables',
        'labor_organization_account_receivables',
        'add_labor_organization_account_receivables',
    ],
);
has_field 'labor_organization_account_payables' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 1,
    label          => 'Accounts Payable',
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Bootstrap3',
        tags           => {wrapper_tag => 'div', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Bootstrap3',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'labor_organization_account_payables.contains' =>
    (type => '+LaborOrganizationAccountPayable',);

has_field 'add_labor_organization_account_payables' => (
    type          => 'AddElement',
    repeatable    => 'labor_organization_account_payables',
    value         => 'Add another account payable',
    element_class => ['btn btn-info']
);

has_field 'labor_organization_account_receivables' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 1,
    label          => 'Accounts Receivable',
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Bootstrap3',
        tags           => {wrapper_tag => 'div', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Bootstrap3',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'labor_organization_account_receivables.contains' =>
    (type => '+LaborOrganizationAccountReceivable',);

has_field 'add_labor_organization_account_receivables' => (
    type          => 'AddElement',
    repeatable    => 'labor_organization_account_receivables',
    value         => 'Add another account receivable',
    element_class => ['btn btn-info']
);

has_block 'assets_block' => (
    tag         => 'div',
    label       => 'Assets',
    render_list => [
        'labor_organization_fixed_assets',
        'add_labor_organization_fixed_assets',
        'labor_organization_investment_assets',
        'add_labor_organization_investment_assets',
        'labor_organization_other_assets',
        'add_labor_organization_other_assets',
        'labor_organization_total_assets',
        'add_labor_organization_total_assets',
    ],
);

has_field 'labor_organization_fixed_assets' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 1,
    label          => 'Fixed Assets',
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Bootstrap3',
        tags           => {wrapper_tag => 'div', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Bootstrap3',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'labor_organization_fixed_assets.contains' =>
    (type => '+LaborOrganizationFixedAsset',);

has_field 'add_labor_organization_fixed_assets' => (
    type          => 'AddElement',
    repeatable    => 'labor_organization_fixed_assets',
    value         => 'Add another fixed asset',
    element_class => ['btn btn-info'],
);

has_field 'labor_organization_investment_assets' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 1,
    label          => 'Investment Assets',
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Bootstrap3',
        tags           => {wrapper_tag => 'div', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Bootstrap3',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'labor_organization_investment_assets.contains' =>
    (type => '+LaborOrganizationInvestmentAsset',);

has_field 'add_labor_organization_investment_assets' => (
    type          => 'AddElement',
    repeatable    => 'labor_organization_investment_assets',
    value         => 'Add another investment asset',
    element_class => ['btn btn-info'],
);

has_field 'labor_organization_other_assets' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 1,
    label          => 'Other Assets',
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Bootstrap3',
        tags           => {wrapper_tag => 'div', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Bootstrap3',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'labor_organization_other_assets.contains' =>
    (type => '+LaborOrganizationOtherAsset',);

has_field 'add_labor_organization_other_assets' => (
    type          => 'AddElement',
    repeatable    => 'labor_organization_other_assets',
    value         => 'Add another other asset',
    element_class => ['btn btn-info'],
);

has_field 'labor_organization_total_assets' => (
    type           => 'Repeatable',
    setup_for_js   => 1,
    do_wrapper     => 1,
    do_label       => 1,
    label          => 'Total Assets',
    num_when_empty => 1,
    num_extra      => 0,
    init_contains  => {
        widget_wrapper => 'Bootstrap3',
        tags           => {wrapper_tag => 'div', controls_div => 1},
        wrapper_class  => ['well-lg'],
    },
    widget_wrapper => 'Bootstrap3',
    tags           => {controls_div => 1},
    wrapper_class  => ['well-lg'],
);
has_field 'labor_organization_total_assets.contains' =>
    (type => '+LaborOrganizationTotalAsset',);

has_field 'add_labor_organization_total_assets' => (
    type          => 'AddElement',
    repeatable    => 'labor_organization_total_assets',
    value         => 'Add antotal total asset',
    element_class => ['btn btn-info'],
);











has_block 'investment_block' => (
    tag         => 'div',
    label       => 'Investments',
    render_list => [
        'investment_purchases',
    ],
);

has_block 'loans_block' => (
    tag         => 'div',
    label       => 'Loans',
    render_list => [
        'loans_payable',
        'loans_receivable',
    ],
);

has_block 'disbursements_block' => (
    tag         => 'div',
    label       => 'Disbursements',
    render_list => [
        'benefits_disbursements',
        'general_disbursements',
        'officer_disbursements',
        'total_disbursements',
    ],
);

has_block 'liabilities_block' => (
    tag         => 'div',
    label       => 'Liabilities',
    render_list => [
        'other_liabilities',
        'total_liabilities',
    ],
);

has_block 'receipts_block' => (
    tag         => 'div',
    label       => 'Receipts',
    render_list => [
        'other_receipts',
        'sales_receipts',
        'total_receipts',
    ],
);

has_block 'payees_block' => (
    tag         => 'div',
    label       => 'Payees',
    render_list => [
        'payees',
    ],
);

has_field 'investment_purchases' => ();

has_field 'loans_payable' => ();

has_field 'loans_receivable' => ();

has_field 'benefits_disbursements' => ();

has_field 'general_disbursements' => ();

has_field 'officer_disbursements' => ();

has_field 'total_disbursements' => ();

has_field 'other_liabilities' => ();

has_field 'total_liabilities' => ();

has_field 'other_receipts' => ();

has_field 'sales_receipts' => ();

has_field 'total_receipts' => ();

has_field 'payees' => ();

has_field 'ports'          => (type => '+Port',);
has_field 'rail_nodes'     => (type => '+RailNode',);
has_field 'warehouses'     => (type => '+Warehouse',);
has_field 'work_stoppages' => (type => '+WorkStoppage',);
has_field 'nlrb_decisions' => (type => '+NLRBDecision',);
has_field 'osha_citations' => (type => '+OSHACitation',);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
);

__PACKAGE__->meta->make_immutable;

1;

