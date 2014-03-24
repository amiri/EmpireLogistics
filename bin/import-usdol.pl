#!/usr/bin/env perl

use strict;
use warnings::everywhere qw/all/;
no goddamn::warnings::anywhere qw/uninitialized/;
use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], '../local');
use lib catpath((splitpath(abs_path $0))[0, 1], '../lib');
use EmpireLogistics::Util::Script;

use IO::All -utf8;
use Text::CSV_XS;
use DBI;
use JSON::XS;
use Data::Printer;
use List::AllUtils qw/any uniq first/;
use Try::Tiny;
use DateTimeX::Easy;
use Tie::IxHash;
use Text::CSV::Encoded  coder_class => 'Text::CSV::Encoded::Coder::EncodeGuess';
use feature qw/say/;

my $dbh = EmpireLogistics::Util::Script->dbh();

my $sth;

my $dir   = "data/labor_organizations/";
# All 13 years is too much data.
my @years = (2013);

# The order in which the files are read.
my %key_for_filename = ();
tie(%key_for_filename, 'Tie::IxHash',
    lm_data_data_                        => 'basic',
    ar_assets_total_data_                => 'total_assets',
    ar_assets_accts_rcvbl_data_          => 'accounts_receivable',
    ar_assets_fixed_data_                => 'fixed_assets',
    ar_assets_loans_rcvbl_data_          => 'loans_receivable',
    ar_assets_investments_data_          => 'investment_assets',
    ar_assets_other_data_                => 'other_assets',
    ar_liabilities_total_data_           => 'total_liabilities',
    ar_liabilities_accts_paybl_data_     => 'accounts_payable',
    ar_liabilities_loans_paybl_data_     => 'loans_payable',
    ar_liabilities_other_data_           => 'other_liabilities',
    ar_receipts_total_data_              => 'total_receipts',
    ar_receipts_inv_fa_sales_data_       => 'sales_receipts',
    ar_receipts_other_data_              => 'other_receipts',
    ar_disbursements_total_data_         => 'total_disbursements',
    ar_disbursements_genrl_data_         => 'general_disbursements',
    ar_disbursements_inv_purchases_data_ => 'investment_purchases',
    ar_disbursements_emp_off_data_       => 'officer_disbursements',
    ar_disbursements_benefits_data_      => 'benefits_disbursements',
    ar_payer_payee_data_                 => 'payees',
    ar_rates_dues_fees_data_             => 'dues',
    ar_membership_data_                  => 'membership',
);

# Dispatch table to process union records. A union record
# consists of all the data for a given union for a given year.
my %process = (
    basic                  => \&process_basic,
    total_assets           => \&process_total_assets,
    accounts_receivable    => \&process_accounts_receivable,
    fixed_assets           => \&process_fixed_assets,
    loans_receivable       => \&process_loans_receivable,
    investment_assets      => \&process_investment_assets,
    other_assets           => \&process_other_assets,
    total_liabilities      => \&process_total_liabilities,
    accounts_payable       => \&process_accounts_payable,
    loans_payable          => \&process_loans_payable,
    other_liabilities      => \&process_other_liabilities,
    total_receipts         => \&process_total_receipts,
    sales_receipts         => \&process_sales_receipts,
    other_receipts         => \&process_other_receipts,
    total_disbursements    => \&process_total_disbursements,
    general_disbursements  => \&process_general_disbursements,
    investment_purchases   => \&process_investment_purchases,
    officer_disbursements  => \&process_officer_disbursements,
    benefits_disbursements => \&process_benefits_disbursements,
    payees                 => \&process_payees,
    dues                   => \&process_dues,
    membership             => \&process_membership,
);

# Some lookup tables to map codes in the original data to
# our enum columns.
my %account_type = (
    101 => 'itemized',
    102 => 'other',
);

my %asset_type = (
    301 => "land",
    302 => "building",
    303 => "automobile",
    304 => "furniture",
    305 => "other",
);

my %loan_type = (
    1001 => 'itemized',
    1002 => 'non-itemized',
);

my %investment_type = (
    701 => "marketable securities",
    702 => "other securities",
    703 => "marketable securities cost",
    704 => "marketable securities book value",
    705 => "other securities cost",
    706 => "other securities book value",
);
my %disbursement_type = (
    501 => "representation",
    502 => "political",
    503 => "contributions",
    504 => "overhead",
    505 => "administration",
    506 => "general",
    507 => "non-itemized",
);
my %payee_type = (
    1001 => 'payer',
    1002 => 'payee',
);
my %membership_type = (
    2101 => 'membership',
    2102 => 'non-itemized',
);

my %local_type = (
    AREA  => 'Area',
    ASSN  => 'Association',
    BCTC  => 'Building and Construction Trades Council',
    BD    => 'Board',
    BR    => 'Branch',
    C     => 'Council',
    CH    => 'Chapter',
    COM   => 'Committee',
    CONBD => 'Conference Board',
    CONF  => 'Conference',
    D     => 'District',
    DALU  => 'Directly Affiliated Local Union',
    DC    => 'District Council',
    DIV   => 'Division',
    DJC   => 'District Joint Council',
    DLG   => 'District Lodge',
    FASTC => 'Food and Allied Services Trades Council',
    FED   => 'Federation',
    GC    => 'General Committee',
    GCA   => 'General Committee of Adjustment',
    JB    => 'Joint Board',
    JC    => 'Joint Council',
    JCONF => 'Joint Conference',
    JPB   => 'Joint Protective Board',
    LCH   => 'Local Chapter',
    LDIV  => 'Local Division',
    LEC   => 'Local Executive Council',
    LG    => 'Lodge',
    LJEB  => 'Local Joint Executive Board',
    LLG   => 'Local Lodge',
    LSC   => 'Local Staff Council',
    LU    => 'Local Union',
    MEC   => 'Master Executive Council',
    MTC   => 'Metal Trades Council',
    NHQ   => 'National Head Quarters',
    PC    => 'Port Council',
    R     => 'Region',
    RC    => 'Regional Council',
    SA    => 'State Association',
    SBA   => 'System Board of Adjustment',
    SC    => 'System Council',
    SCOM  => 'System Committee',
    SD    => 'System Division',
    SF    => 'System Federal',
    SFED  => 'State Federation',
    SLB   => 'State Legislative Board',
    SLG   => 'Sub-Lodge',
    STC   => 'State Council',
    STCON => 'State Conference',
    UNIT  => 'Unit',
);

=head2 dispatch table subroutines

Implementations of the subroutines in the dispatch table.

=cut

sub process_basic {
    my ($data) = shift;
    return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            abbreviation
            union_name
            usdol_filing_number
            unit_name
            designation
            designation_number
            designation_suffix
            designation_prefix
            date_established
            members
            street_address
            city
            state
            zip
            total_assets
            total_liabilities
            total_disbursements
            total_receipts
            /
        }
        = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$data}{
        qw/
            AFF_ABBR
            UNION_NAME
            F_NUM
            UNIT_NAME
            DESIG_NAME
            DESIG_NUM
            DESIG_SUF
            DESIG_PRE
            EST_DATE
            MEMBERS
            STREET_ADR
            CITY
            STATE
            ZIP
            TTL_ASSETS
            TTL_LIABILITIES
            TTL_DISBURSEMENTS
            TTL_RECEIPTS
            /
        };
    return $return;
}

sub process_total_assets {
    my ($data) = shift;
    return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            accounts_receivable_end
            accounts_receivable_start
            cash_end
            cash_start
            fixed_assets_end
            fixed_assets_start
            investments_end
            investments_start
            loans_receivable_end
            loans_receivable_start
            securities_book_value
            securities_cost
            other_assets_end
            other_assets_start
            other_investments_book_value
            other_investments_cost
            total_start
            treasuries_end
            treasuries_start
            /
        }
        = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$data}{
        qw/
            ACCOUNTS_RECEIVABLE_END
            ACCOUNTS_RECEIVABLE_START
            CASH_END
            CASH_START
            FIXED_ASSETS_END
            FIXED_ASSETS_START
            INVESTMENTS_END
            INVESTMENTS_START
            LOANS_RECEIVABLE_END
            LOANS_RECEIVABLE_START
            MARKET_SEC_TOTAL_BOOK_VALUE
            MARKET_SEC_TOTAL_COST
            OTHER_ASSETS_END
            OTHER_ASSETS_START
            OTHER_INV_TOTAL_BOOK_VALUE
            OTHER_INV_TOTAL_COST
            TOTAL_START
            TREASURY_SECURITIES_END
            TREASURY_SECURITIES_START
            /
        };
    return $return;
}

sub process_accounts_receivable {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
        @{$each}{
            qw/
                account_type
                liquidated
                name
                past_due_90
                past_due_180
                total
                /
            }
            = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
            qw/
                ACCT_TYPE
                LIQUIDATED
                NAME
                PAST_DUE_90
                PAST_DUE_180
                TOTAL
                /
            };
            $each;
        } @$data
    ];
    return $return;
}

sub process_fixed_assets {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each   = {};
            my $record = $_;
            @{$each}{
                qw/
                    asset_type
                    book_value
                    cost_basis
                    depreciation
                    description
                    value
                    /
                }
            = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    ASSET_TYPE
                    BOOK_VALUE
                    COST_BASIS
                    DEPRECIATION
                    DESCRIPTION
                    VALUE
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_loans_receivable {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    cash_repayments
                    loan_type
                    name
                    new_loan_amount
                    non_cash_repayments
                    outstanding_end_amount
                    outstanding_start_amount
                    purpose
                    security
                    terms
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    CASH_REPAYMENTS
                    LOAN_TYPE
                    NAME
                    NEW_LOAN_AMT
                    NON_CASH_REPAYMENTS
                    OUTSTANDING_END_AMT
                    OUTSTANDING_START_AMT
                    PURPOSE
                    SECURITY
                    TERMS
                    /
                };
            $each;
        }
        @$data
    ];
    return $return;
}

sub process_investment_assets {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    amount
                    investment_type
                    name
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    AMOUNT
                    INV_TYPE
                    NAME
                    /
                };
            $each;
        }
        @$data
    ];
    return $return;
}

sub process_other_assets {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    book_value
                    description
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$_}{
                qw/
                    BOOK_VALUE
                    DESCRIPTION
                    /
                };
            $each;
        }
        @$data
    ];
    return $return;
}

sub process_total_liabilities {
    my ($data) = shift;
    return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            accounts_payable_end
            accounts_payable_start
            loans_payable_end
            loans_payable_start
            mortgages_payable_end
            mortgages_payable_start
            other_liabilities_end
            other_liabilities_start
            total_start
            /
        }
        = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$data}{
        qw/
            ACCOUNTS_PAYABLE_END
            ACCOUNTS_PAYABLE_START
            LOANS_PAYABLE_END
            LOANS_PAYABLE_START
            MORTGAGE_PAYABLE_END
            MORTGAGE_PAYABLE_START
            OTHER_LIABILITIES_END
            OTHER_LIABILITIES_START
            TOTAL_START
            /
        };
    return $return;
}

sub process_accounts_payable {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    account_type
                    liquidated
                    name
                    past_due_90
                    past_due_180
                    total
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    ACCT_TYPE
                    LIQUIDATED
                    NAME
                    PAST_DUE_90
                    PAST_DUE_180
                    TOTAL
                    /
                };
           $each; 
        } @$data
    ];
    return $return;
}

sub process_loans_payable {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    cash_repayment
                    loans_obtained
                    loans_owed_end
                    loans_owed_start
                    non_cash_repayment
                    source
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    CASH_REPAYMENT
                    LOANS_OBTAINED
                    LOANS_OWED_END
                    LOANS_OWED_START
                    NON_CASH_REPAYMENT
                    SOURCE
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_other_liabilities {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    amount
                    description
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    AMOUNT
                    DESCRIPTION
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_total_receipts {
    my ($data) = shift;
    return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            affiliates
            all_other_receipts
            dividends
            dues
            fees
            interest
            investments
            loans_made
            loans_taken
            members
            other_receipts
            rents
            office_supplies
            tax
            /
        }
        = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$data}{
        qw/
            AFFILIATES
            ALL_OTHER_RECEIPTS
            DIVIDENDS
            DUES
            FEES
            INTEREST
            INVESTMENTS
            LOANS_MADE
            LOANS_OBTAINED
            MEMBERS
            OTHER_RECEIPTS
            RENTS
            SUPPLIES
            TAX
            /
        };
    return $return;
}

sub process_sales_receipts {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    amount_received
                    book_value
                    cost
                    description
                    gross_sales_price
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    AMOUNT_RECD
                    BOOK_VALUE
                    COST
                    DESCRIPTION
                    GROSS_SALES_PRICE
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_other_receipts {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    amount
                    receipt_date
                    payee
                    purpose
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    AMOUNT
                    DATE
                    PAYER_PAYEE_ID
                    PURPOSE
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_total_disbursements {
    my ($data) = shift;
    return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            administration
            affiliates
            other_contributions
            other_general_overhead
            other_political
            other_representation
            other_union_administration
            benefits
            contributions
            taxes
            education
            employee_salaries
            fees
            general_overhead
            investments
            loans_made
            loans_paid
            members
            officer_administration
            officer_salaries
            other
            per_capita_tax
            political
            professional_services
            representation
            strike_benefits
            office_supplies
            employees_total
            officers_total
            union_administration
            withheld
            withheld_not_disbursed
            /
        }
        = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$data}{
        qw/
            ADMINISTRATION
            AFFILIATES
            ALL_OTHER_CONTRIBUTIONS
            ALL_OTHER_GEN_OVERHEAD
            ALL_OTHER_POL_ACTIVITIES
            ALL_OTHER_REP_ACTIVITIES
            ALL_OTHER_UNION_ADMIN
            BENEFITS
            CONTRIBUTIONS
            DIRECT_TAXES
            EDU_PUB_EXPENSE
            EMPLOYEE_DEDUCTIONS
            FEES
            GENERAL_OVERHEAD
            INVESTMENTS
            LOANS_MADE
            LOANS_PAYMENT
            MEMBERS
            OFF_ADMIN_EXPENSE
            OFFICER_DEDUCTIONS
            OTHER_DISBURSEMENTS
            PER_CAPITA_TAX
            POLITICAL
            PRO_FEES
            REPRESENTATIONAL
            STRIKE_BENEFITS
            SUPPLIES
            TO_EMPLOYEES
            TO_OFFICERS
            UNION_ADMINISTRATION
            WITHHELD
            WITHHELD_NOT_DISBURSED
            /
        };
    return $return;
}

sub process_general_disbursements {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    amount
                    disbursement_date
                    disbursement_type
                    payee
                    purpose
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    AMOUNT
                    DATE
                    DISBURSEMENT_TYPE
                    PAYER_PAYEE_ID
                    PURPOSE
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_investment_purchases {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    book_value
                    cash_paid
                    cost
                    description
                    investment_type
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    BOOK_VALUE
                    CASH_PAID
                    COST
                    DESCRIPTION
                    INV_TYPE
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_officer_disbursements {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    first_name
                    middle_name
                    last_name
                    title
                    gross_salary
                    representation_percent
                    political_percent
                    contributions_percent
                    general_overhead_percent
                    administration_percent
                    total
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    FIRST_NAME
                    MIDDLE_NAME
                    LAST_NAME
                    TITLE
                    GROSS_SALARY
                    REP_PCT
                    POL_PCT
                    CONT_PCT
                    GEN_OVRHD_PCT
                    ADMIN_PCT
                    TOTAL
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_benefits_disbursements {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
        @{$each}{
            qw/
                amount
                description
                paid_to
                /
            }
            = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
            qw/
                AMOUNT
                DESCRIPTION
                PAID_TO
                /
            };
            $each;
        } @$data
    ];
    return $return;
}

sub process_payees {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    city
                    name
                    payee
                    payer_payee_type
                    po_box
                    rcpt_disb_type
                    state
                    street
                    total
                    type_or_class
                    zip
                    /
                }
                = map {trim($_)} @{$record}{
                qw/
                    CITY
                    NAME
                    PAYER_PAYEE_ID
                    PAYER_PAYEE_TYPE
                    PO_BOX
                    RCPT_DISB_TYPE
                    STATE
                    STREET
                    TOTAL
                    TYPE_OR_CLASS
                    ZIP
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_dues {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    amount
                    maximum
                    minimum
                    unit
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    AMOUNT
                    MAXIMUM
                    MINIMUM
                    UNIT
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub process_membership {
    my ($data) = shift;
    return undef unless $data;
    my $return = [];
    $return = [
        map {
            my $each = {};
            my $record = $_;
            @{$each}{
                qw/
                    category
                    membership_type
                    number
                    voting_eligibility
                    /
                }
                = map { my $datum = $_; my $return_datum = $datum eq "" ? undef : $datum; $return_datum } map { trim($_) } @{$record}{
                qw/
                    CATEGORY
                    MEMBERSHIP_TYPE
                    NUMBER
                    VOTING_ELIGIBILITY
                    /
                };
            $each;
        } @$data
    ];
    return $return;
}

sub trim {
    my ($string) = @_;
    $string =~ s/^\s+//g;
    $string =~ s/\s+$//g;
    return $string;
}

my $csv = Text::CSV::Encoded->new(
    {   allow_loose_quotes => 1,
        binary             => 1,
        auto_diag          => 1,
        sep_char           => "|",
        escape_char        => undef,
        quote_char         => undef,
        blank_is_undef     => 1,
        empty_is_undef     => 1,
        eol                => $/,
    }
);

$csv->encoding_in( ['iso-8859-1', 'cp1252', 'ascii'] );
$csv->encoding_out('utf8');

my %union_data = ();

my %primary_key_for_rpt_id_year = ();

# This gathers all the file data into a gigantic hashref keyed
# on the filing number of each union. The filing number remains
# the same across years, but the report id changes from year to
# year. So we need to save the "primary key for report id and year"
# for every year. We do that by looking at the files in a particular
# order, namely, the lm_data_data file, which contains the filing
# number and that year's RPT_ID, has to come first for every
# year, so that we can set this. The RPT_ID is in every file,
# but the filing number is only in the lm_data_data file, so we
# have to check that first.
for my $year (@years) {
    my $subdir = $dir . $year . '/';

    # For every file in our list of files
    for my $file_name ( keys %key_for_filename ) {
        my $file = $subdir . $file_name . $year . '.txt';
        my $io   = io($file);
        $csv->column_names( $csv->getline($io) );

        # Turn every line in the file into a hashref, signifying
        # a record of one of the types. The types are basically
        # what sort of record the file contains. If the file is
        # ar_disbursements_emp_off_data_, each line is an
        # officer_disbursement record.
        while (my $row = $csv->getline_hr($io)) {
            # The lm_data_data file will come first because we set
            # the order in %keys_for_filename.
            if ($file_name eq 'lm_data_data_') {
                # The primary key is the filing number. Given a report id
                # and year, we set that report_id/year combination's PK
                # to the filing number. We will refer to this in every file
                # processed. We establish it while processing lm_data_data.
                my $primary_key = $row->{F_NUM} || ''
                    ;
                $primary_key_for_rpt_id_year{$row->{RPT_ID} . '-' . $year} =
                    $primary_key;
            }
            # Some types are "arrays," meaning they contain multiple records instead
            # of just one. Do those first.
            if ($file_name =~ /^ar/ && $file_name !~ /total/) {
                # Try to push the record into the proper array slot
                try {
                    $union_data{$primary_key_for_rpt_id_year{($row->{RPT_ID}||'').'-'.$year}}{$year}{$key_for_filename{$file_name}} = []
                        unless $union_data{$primary_key_for_rpt_id_year{($row->{RPT_ID}||'').'-'.$year}}{$year}{$key_for_filename{$file_name}};
                    push @{$union_data{$primary_key_for_rpt_id_year{($row->{RPT_ID}||'').'-'.$year}}{$year}{$key_for_filename{$file_name}}}, $row
                    ;
                } catch {
                    say "Could not set data; RPT_ID: ", $row->{RPT_ID}, "; year: $year; filename: $file_name; key for filename: ",  $key_for_filename{$file_name}, "; row: ", p $row, "; error: $_";
                }
            # For non-array records, just pop it in.
            } else {
                # Put the record into the proper slot
                try {
                    $union_data{$primary_key_for_rpt_id_year{($row->{RPT_ID}||'').'-'.$year}}{$year}{$key_for_filename{$file_name}} = $row
                    ;
                } catch {
                    say "Could not set data; RPT_ID: ", $row->{RPT_ID}, "; year: $year; filename: $file_name; key for filename: ",  $key_for_filename{$file_name}, "; row: ", p $row, "; error: $_";
                }
            }
        }
    }
}

=head2 EXTRACT USDOL ABBREVIATIONS

say "Number of unions: ", scalar keys %union_data;
my @labor_orgs;
for my $year (@years) {
    push @labor_orgs, map { $union_data{$_}{$year}{basic}{AFF_ABBR} => trim($union_data{$_}{$year}{basic}{UNION_NAME}) } keys %union_data;
}
my %labor_orgs = @labor_orgs;
%labor_orgs = reverse %labor_orgs;
say p %labor_orgs;

=cut

# Here we do our saving. We pre-process the data in the hashref,
# chop it up and format it to suit our needs, and then save each
# piece appropriately.
UNION: for my $key ((sort {$a <=> $b} keys %union_data)) {
    my $union_data_for_year = $union_data{$key};
    #next unless $key == 14910;

    my ($first_basic) = map {$union_data_for_year->{$_}{basic}}
        first {defined($union_data_for_year->{$_}{basic})}
    sort keys %$union_data_for_year;
    my $first_basic_year = first {defined($union_data_for_year->{$_}{basic})}
    sort keys %$union_data_for_year;
    $first_basic = $process{basic}->($first_basic);
    #die p $first_basic if $first_basic->{usdol_filing_number} == 14910;
    
    # We need the labor_organization already defined
    # before we enter the year loop.
    my $id = save_local_or_organization($first_basic,$first_basic_year);

    YEAR: for my $year (sort keys %$union_data_for_year) {
        my %record = ();

        # Basic
        $record{basic} =
            $process{basic}->($union_data_for_year->{$year}{basic});

        # Payees
        $record{payees} =
            $process{payees}->($union_data_for_year->{$year}{payees});

        # Assets
        $record{other_assets} = $process{other_assets}
            ->($union_data_for_year->{$year}{other_assets});
        $record{fixed_assets} = $process{fixed_assets}
            ->($union_data_for_year->{$year}{fixed_assets});
        $record{investment_assets} = $process{investment_assets}
            ->($union_data_for_year->{$year}{investment_assets});
        $record{total_assets} = $process{total_assets}
            ->($union_data_for_year->{$year}{total_assets});

        # Accounts
        $record{accounts_receivable} = $process{accounts_receivable}
            ->($union_data_for_year->{$year}{accounts_receivable});
        $record{accounts_payable} = $process{accounts_payable}
            ->($union_data_for_year->{$year}{accounts_payable});

        # Loans
        $record{loans_receivable} = $process{loans_receivable}
            ->($union_data_for_year->{$year}{loans_receivable});
        $record{loans_payable} = $process{loans_payable}
            ->($union_data_for_year->{$year}{loans_payable});

        # Liabilities
        $record{total_liabilities} = $process{total_liabilities}
            ->($union_data_for_year->{$year}{total_liabilities});
        $record{other_liabilities} = $process{other_liabilities}
            ->($union_data_for_year->{$year}{other_liabilities});

        # Receipts
        $record{sales_receipts} = $process{sales_receipts}
            ->($union_data_for_year->{$year}{sales_receipts});
        $record{other_receipts} = $process{other_receipts}
            ->($union_data_for_year->{$year}{other_receipts});
        $record{total_receipts} = $process{total_receipts}
            ->($union_data_for_year->{$year}{total_receipts});

        # Disbursements
        $record{general_disbursements} = $process{general_disbursements}
            ->($union_data_for_year->{$year}{general_disbursements});
        $record{investment_purchases} = $process{investment_purchases}
            ->($union_data_for_year->{$year}{investment_purchases});
        $record{officer_disbursements} = $process{officer_disbursements}
            ->($union_data_for_year->{$year}{officer_disbursements});
        $record{benefits_disbursements} = $process{benefits_disbursements}
            ->($union_data_for_year->{$year}{benefits_disbursements});
        $record{total_disbursements} = $process{total_disbursements}
            ->($union_data_for_year->{$year}{total_disbursements});

        ## Dues types
        #$record{dues} = $process{dues}->($union_data_for_year->{$year}{dues});

        ## Membership types
        #$record{membership} =
            #$process{membership}->($union_data_for_year->{$year}{membership});

        # CREATE YEAR RECORDS
        # Basic
        #   Create members record from basic
        create_membership($record{basic},$id,$year) if $record{basic}->{members};
        #   Create address record from basic
        create_labor_address($record{basic},$id,$year);
        
        # Payees
        #   Create all payees from payees 
        create_payees($record{payees},$id,$year) if $record{payees} && scalar @{$record{payees}} > 0;

        # Assets
        #   Other
        create_other_assets($record{other_assets},$id,$year);
        #   Fixed
        create_fixed_assets($record{fixed_assets},$id,$year);
        #   Investment
        create_investment_assets($record{investment_assets},$id,$year);
        #   Total
        create_total_assets($record{total_assets},$id,$year);

        # Accounts
        #   Payable
        create_accounts_payable($record{accounts_payable},$id,$year);
        #   Receivable
        create_accounts_receivable($record{accounts_receivable},$id,$year);

        # Loans 
        #   Payable
        create_loans_payable($record{loans_payable},$id,$year);
        #   Receivable
        create_loans_receivable($record{loans_receivable},$id,$year);

        # Liabilities
        #   Other
        create_other_liabilities($record{other_liabilities},$id,$year);
        #   Total
        create_total_liabilities($record{total_liabilities},$id,$year);

        # Receipts
        #   Sales
        create_sales_receipts($record{sales_receipts},$id,$year);
        #   Other
        create_other_receipts($record{other_receipts},$id,$year,($record{payees}||[]));
        #   Total
        create_total_receipts($record{total_receipts},$id,$year);

        # Disbursements
        #   General
        create_general_disbursements($record{general_disbursements},$id,$year,($record{payees}||[]));
        #   Investment
        create_investment_purchases($record{investment_purchases},$id,$year);
        #   Officers
        create_officer_disbursements($record{officer_disbursements},$id,$year);
        #   Benefits
        create_benefit_disbursements($record{benefits_disbursements},$id,$year);
        #   Total
        create_total_disbursements($record{total_disbursements},$id,$year);
        $dbh->commit;
    }
}

sub save_local_or_organization {
    my ($data, $year) = @_;
    # These are what we will return
    my $id;

    # If there is an abbreviation and it is not UNAFF
    if ($data->{abbreviation} && $data->{abbreviation} !~ /unaff/i) {
        # Try to find the labor_organization to which the local belongs
        #say "I have an abbrev and it is not unaff";
        my $org_id = find_org($data->{abbreviation});
        my ($local_id, $new_org_id);
        # If we found the labor_organization
        $data->{labor_organization_type} = 'local';
        if ($org_id) {
        #say "I have an org id $org_id";
            $local_id = create_local($data);
            my $aff_id = create_affiliation($local_id, $org_id, $year);
        # If we did not find the organization
        } else {
        #say "I do not have an org id and will create one";
            $new_org_id = create_organization($data);
            $local_id   = create_local($data);
            my $aff_id = create_affiliation($local_id, $new_org_id, $year);
        }
        # Set our return vars
        $id = $local_id;
    # If there is an abbreviation and it is UNAFF and there is some labor_local data
    } elsif (
        $data->{abbreviation}
        && $data->{abbreviation} =~ /unaff/i
        && (   $data->{designation}
            || $data->{designation_number}
            || $data->{designation_prefix}
            || $data->{designation_suffix})
        )
    {
        #say "I have an unaff local";
        # Create an unaffiliated local
        $data->{labor_organization_type} = 'unaffiliated';
        my $local_id = create_local($data);
        # Set our return vars
        $id = $local_id;
    # If there is no abbreviation
    } else {
        #say "I have an new organization";
        # Create an organization
        $data->{labor_organization_type} = 'union';
        my $organization_id = create_organization($data);
        # Set our return vars
        $id = $organization_id;
    }
    $dbh->commit;
    return $id;
}

sub find_org {
    my $abbreviation = shift;
    my $find_org = 'select id from labor_organization where abbreviation = ?';
    $sth = $dbh->prepare($find_org);
    my $org_id;
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($abbreviation);
            my $id = $sth->fetchrow_arrayref;
            $org_id = defined($id) ? $id->[0] : undef;
        } catch {
            say "Could not execute: $_";
        };
    }
    $dbh->commit;
    #say "Found an org: $org_id" if $org_id;
    return $org_id;
}

sub create_local {
    my $data = shift;
    my $create_local = 'insert into labor_organization (name,usdol_filing_number,local_prefix,local_suffix,local_type,local_number,date_established,organization_type) values (?,?,?,?,?,?,?,?)';
    my $local_name = $data->{union_name};
    my $abb = $data->{abbreviation};
    $local_name =~ s/(.+)\s+$abb.+/$1/g;
    my $local_name   = join(" ", (map {ucfirst lc} (split(/ /, $local_name))));
    my $local_type   = $local_type{$data->{designation}};
    my $local_number = $data->{designation_number};
    my $local_prefix = $data->{designation_prefix};
    my $local_suffix = $data->{designation_suffix};
    my $filing_number = $data->{usdol_filing_number};
    my $date_established = $data->{date_established} ? DateTimeX::Easy->new($data->{date_established}) : undef;
    my $local_id;
    my $find_local = "select id from labor_organization where name = ? and usdol_filing_number = ? and organization_type = 'local' and abbreviation is null and local_prefix = ? and local_suffix = ? and local_number = ?";
    # Find the local first
    $sth = $dbh->prepare($find_local);
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($local_name,$filing_number,$local_prefix,$local_suffix,$local_number);
            my $id = $sth->fetchrow_arrayref;
            $local_id = defined($id) ? $id->[0] : undef;
        } catch {
            say "Could not execute: $_";
        };
    }
    #say "I found a local: $local_id" if $local_id;
    # Only create it if we have to
    unless ($local_id) {
        #say "Did not find a local; creating..";
        $sth = $dbh->prepare($create_local);
        $dbh->pg_savepoint("create_local");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($local_name,$filing_number,$local_prefix,$local_suffix,$local_type,$local_number,$date_established,'local');
                $local_id = $dbh->last_insert_id( undef, undef, "labor_organization", undef );
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("create_local");
            };
        }
        $dbh->commit;
    }
    return $local_id;
}

sub create_organization {
    my $data = shift;
    my $create_organization = 'insert into labor_organization (name,usdol_filing_number,abbreviation,date_established) values (?,?,?,?)';
    my $org_name = join(" ", (map {ucfirst lc} (split(/ /, $data->{union_name}))));
    $sth = $dbh->prepare($create_organization);
    my $org_abbreviation = $data->{abbreviation};
    $org_abbreviation = undef if $org_abbreviation =~ /unaff/i;
    my $date_established = $data->{date_established} ? DateTimeX::Easy->new($data->{date_established}) : undef;
    my $filing_number = $data->{usdol_filing_number};
    my $org_id;
    $dbh->pg_savepoint("create_organization");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($org_name,$filing_number,$org_abbreviation,$date_established);
            $org_id = $dbh->last_insert_id( undef, undef, "labor_organization", undef );
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("create_organization");
        };
    }
    $dbh->commit;
    return $org_id;
}

sub create_affiliation {
    my ($local_id, $org_id, $year) = @_;
    my $create_affiliation = 'insert into labor_organization_affiliation (child,parent,year) values (?,?,?)';
    $sth = $dbh->prepare($create_affiliation);
    my $affid;
    $dbh->pg_savepoint("create_affiliation");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($local_id,$org_id,$year);
            $affid = $dbh->last_insert_id( undef, undef, "labor_organization_affiliation", undef );
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("create_affiliation");
        };
    }
    $dbh->commit;
    return $affid;
}

sub create_payee_address {
    my ($payee_id, $address_id,$year) = @_;
    my $type = "labor_organization";
    #say "No address" unless $address_id;
    #say "No year" unless $year;
    my $table_name = $type."_payee_address";
    my $rel_name = $type."_payee";
    my $create_address = "insert into $table_name ($rel_name,address,year) values (?,?,?)";
    $sth = $dbh->prepare($create_address);
    my $payee_address_id;
    $dbh->pg_savepoint("create_payee_address");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($payee_id,$address_id,$year);
            $payee_address_id = $dbh->last_insert_id( undef, undef, $table_name, undef );
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("create_payee_address");
        };
    }
    $dbh->commit;
    return $payee_address_id;
}

sub create_membership {
    my ($data,$id,$year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_membership";
    my $create_membership = "insert into $table_name ($type,year,members) values (?,?,?)";
    $sth = $dbh->prepare($create_membership);
    my $membership_id;
    $dbh->pg_savepoint("create_membership");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($id,$year,$data->{members});
            $membership_id = $dbh->last_insert_id( undef, undef, $table_name, undef );
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("create_membership");
        };
    }
    $dbh->commit;
    return $membership_id;
}

sub create_payees {
    my ($data,$id,$year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_payee";
    for my $payee (@$data) {
        my $create_payee = "insert into $table_name ($type,year,name,payee_type,payment_type,amount,usdol_payee_id) values (?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_payee);
        my $amount = $payee->{total};
        $amount = undef if defined($amount) and !$amount;
        my $payee_type = $payee_type{$payee->{payer_payee_type}};
        my $name = $payee->{name};
        my $payment_type = $payee->{type_or_class};
        my $street_address = $payee->{street};
        my $city = $payee->{city};
        my $state = $payee->{state};
        my $zip = $payee->{zip};
        my $usdol_payee_id = $payee->{payee};
        #say "Id: $id, year: $year, name: $name, payee_type: $payee_type, payment_type: $payment_type, amount: $amount, payee_id: $usdol_payee_id";
        $dbh->pg_savepoint("create_payee");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,$name,$payee_type,$payment_type,$amount,$usdol_payee_id);
                my $payee_id = $dbh->last_insert_id( undef, undef, $table_name, undef );
                my $address_id = create_address({
                    street_address => $street_address,
                    city           => $city,
                    state          => $state,
                    postal_code    => $zip,
                    country        => 'US'
                });
                my $payee_address_id = create_payee_address($payee_id,$address_id,$year) if $address_id;
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("create_payee");
            };
        }
        $dbh->commit;
    }
}

sub create_total_disbursements {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id"   unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type . "_total_disbursement";
    my $create_total_disbursement = "insert into $table_name ($type,year,administration,affiliates,benefits,contributions,education,employee_salaries,employees_total,fees,general_overhead,investments,loans_made,loans_paid,members,officer_administration,officer_salaries,officers_total,office_supplies,other,other_contributions,other_general_overhead,other_political,other_representation,other_union_administration,per_capita_tax,political,professional_services,representation,strike_benefits,taxes,union_administration,withheld,withheld_not_disbursed) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    $sth = $dbh->prepare($create_total_disbursement);
    $dbh->pg_savepoint("create_total_disbursements");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($id, $year, @{$data}{qw/administration affiliates benefits contributions education employee_salaries employees_total fees general_overhead investments loans_made loans_paid members officer_administration officer_salaries officers_total office_supplies other other_contributions other_general_overhead other_political other_representation other_union_administration per_capita_tax political professional_services representation strike_benefits taxes union_administration withheld withheld_not_disbursed/});
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("create_total_disbursements");
        };
    }
    $dbh->commit;
    return 1;
}

sub identify_payee {
    my ($payee_number,$payees) = @_;
    my ($payee_name) = map { $_->{name} } grep { $_->{payee} == $payee_number } @$payees;
    return $payee_name;
}

sub create_general_disbursements {
    my ($data, $id, $year, $payees) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    #say "No payees" unless $payees;
    my $table_name = $type."_general_disbursement";
    for my $disbursement (@$data) {
        my $disbursement_date = $disbursement->{disbursement_date} ? DateTimeX::Easy->new($disbursement->{disbursement_date}) : undef;
        my $disbursement_type = $disbursement_type{$disbursement->{disbursement_type}};
        my $payee_name = identify_payee($disbursement->{payee},$payees);
        my $usdol_payee_id = $disbursement->{payee};
        my $amount = $disbursement->{amount};
        $amount = undef if defined($amount) and !$amount;
        my $create_general_disbursement = qq{insert into $table_name ($type,year,payee,disbursement_date,disbursement_type,amount,purpose) values (?,?,(select id from labor_organization_payee where name = \$\$$payee_name\$\$ and usdol_payee_id = $usdol_payee_id and labor_organization = $id),?,?,?,?)};
        say $create_general_disbursement;
        $sth = $dbh->prepare($create_general_disbursement);
        $dbh->pg_savepoint("general_disbursement");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,$disbursement_date,$disbursement_type,$amount,@{$disbursement}{qw/purpose/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("general_disbursement");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_officer_disbursements {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_officer_disbursement";
    for my $disbursement (@$data) {
        my $create_officer_disbursement = "insert into $table_name ($type,year,first_name,middle_name,last_name,administration_percent,contributions_percent,general_overhead_percent,gross_salary,political_percent,representation_percent,title,total) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_officer_disbursement);
        my $disbursement_type = $disbursement_type{$disbursement->{disbursement_type}};
        $dbh->pg_savepoint("officer_disbursement");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,@{$disbursement}{qw/first_name middle_name last_name administration_percent contributions_percent general_overhead_percent gross_salary political_percent representation_percent title total/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("officer_disbursement");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_benefit_disbursements {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_benefit_disbursement";
    for my $disbursement (@$data) {
        my $create_benefit_disbursement = "insert into $table_name ($type,year,amount,description,paid_to) values (?,?,?,?,?)";
        my $amount = $disbursement->{amount};
        $amount = undef if defined($amount) and !$amount;
        $sth = $dbh->prepare($create_benefit_disbursement);
        $dbh->pg_savepoint("benefit_disbursement");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,$amount,@{$disbursement}{qw/description paid_to/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("benefit_disbursement");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_investment_purchases {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_investment_purchase";
    for my $investment_purchase (@$data) {
        my $create_investment_purchase = "insert into $table_name ($type,year,book_value,cash_paid,cost,description,investment_type) values (?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_investment_purchase);
        my $investment_type = $investment_type{$investment_purchase->{investment_type}};
        $dbh->pg_savepoint("investment_purchase");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,@{$investment_purchase}{qw/book_value cash_paid cost description/},$investment_type);
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("investment_purchase");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_total_receipts {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id"   unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type . "_total_receipt";
    my $create_total_receipt = "insert into $table_name ($type,year,affiliates,all_other_receipts,dividends,dues,fees,interest,investments,loans_made,loans_taken,members,office_supplies,other_receipts,rents,tax) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    $sth = $dbh->prepare($create_total_receipt);
    $dbh->pg_savepoint("create_total_receipt");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute($id, $year, @{$data}{qw/affiliates all_other_receipts dividends dues fees interest investments loans_made loans_taken members office_supplies other_receipts rents tax/});
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("create_total_receipt");
        };
    }
    $dbh->commit;
    return 1;
}

sub create_sales_receipts {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_sale_receipt";
    for my $receipt (@$data) {
        my $create_sale_receipt = "insert into $table_name ($type,year,amount_received,book_value,cost,description,gross_sales_price) values (?,?,?,?,?,?,?)";
        my $amount = $receipt->{amount_received};
        $amount = undef if defined($amount) and !$amount;
        my $book_value = $receipt->{book_value};
        $book_value = undef if defined($book_value) and !$book_value;
        my $cost = $receipt->{cost};
        $cost = undef if defined($cost) and !$cost;
        my $gross_sales_price = $receipt->{gross_sales_price};
        $gross_sales_price = undef if defined($gross_sales_price) and !$gross_sales_price;
        $sth = $dbh->prepare($create_sale_receipt);
        $dbh->pg_savepoint("sale_receipt");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,$amount,$book_value,$cost,@{$receipt}{qw/description/},$gross_sales_price);
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("sale_receipt");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_other_receipts {
    my ($data, $id, $year,$payees) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    #say "No payees" unless $payees;
    my $table_name = $type."_other_receipt";
    for my $receipt (@$data) {
        my $receipt_date = $receipt->{receipt_date} ? DateTimeX::Easy->new($receipt->{receipt_date}) : undef;
        my $payee_name = identify_payee($receipt->{payee},$payees);
        my $usdol_payee_id = $receipt->{payee};
        my $create_other_receipt = qq{insert into $table_name ($type,year,payee,receipt_date,amount,purpose) values (?,?,(select id from labor_organization_payee where name = \$\$$payee_name\$\$ and usdol_payee_id = $usdol_payee_id and labor_organization = $id),?,?,?)};
        $sth = $dbh->prepare($create_other_receipt);
        $dbh->pg_savepoint("other_receipt");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,$receipt_date,@{$receipt}{qw/amount purpose/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("other_receipt");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_total_assets {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id"   unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type . "_total_asset";
    my $create_total_asset =
        "insert into $table_name ($type,year,accounts_receivable_end,accounts_receivable_start,cash_end,cash_start,fixed_assets_end,fixed_assets_start,investments_end,investments_start,loans_receivable_end,loans_receivable_start,other_assets_end,other_assets_start,other_investments_book_value,other_investments_cost,securities_book_value,securities_cost,total_start,treasuries_end,treasuries_start) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    $sth = $dbh->prepare($create_total_asset);
    $dbh->pg_savepoint("create_total_asset");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute(
                $id, $year,
                @{$data}{
                    qw/accounts_receivable_end accounts_receivable_start cash_end cash_start fixed_assets_end fixed_assets_start investments_end investments_start loans_receivable_end loans_receivable_start other_assets_end other_assets_start other_investments_book_value other_investments_cost securities_book_value securities_cost total_start treasuries_end treasuries_start/
                }
            );
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("create_total_asset");
        };
    }
    $dbh->commit;
    return 1;
}

sub create_total_liabilities {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id"   unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type . "_total_liability";
    my $create_total_liability =
        "insert into $table_name ($type,year,accounts_payable_end,accounts_payable_start,loans_payable_end,loans_payable_start,mortgages_payable_end,mortgages_payable_start,other_liabilities_end,other_liabilities_start,total_start) values (?,?,?,?,?,?,?,?,?,?,?)";
    $sth = $dbh->prepare($create_total_liability);
    $dbh->pg_savepoint("total_liability");
    {
        local $dbh->{RaiseError};
        try {
            $sth->execute( $id, $year, @{$data}{qw/accounts_payable_end accounts_payable_start loans_payable_end loans_payable_start mortgages_payable_end mortgages_payable_start other_liabilities_end other_liabilities_start total_start/});
        } catch {
            say "Could not execute: $_";
            $dbh->pg_rollback_to("total_liability");
        };
    }
    $dbh->commit;
    return 1;
}

sub create_other_liabilities {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_other_liability";
    for my $liability (@$data) {
        my $create_other_liability = "insert into $table_name ($type,year,amount,description) values (?,?,?,?)";
        $sth = $dbh->prepare($create_other_liability);
        $dbh->pg_savepoint("other_liability");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,@{$liability}{qw/amount description/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("other_liability");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_accounts_receivable {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_account_receivable";
    my $i = 0;
    for my $account (@$data) {
        my $create_account_receivable = "insert into $table_name ($type,year,account_type,liquidated,name,past_due_90,past_due_180,total) values (?,?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_account_receivable);
        my $account_type = $account_type{$account->{account_type}};
        $dbh->pg_savepoint("account_receivable");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,$account_type,@{$account}{qw/liquidated name past_due_90 past_due_180 total/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("account_receivable");
            };
        }
        #say "$i accounts_receivable";
        $i++;
        $dbh->commit;
    }
    return 1;
}
sub create_accounts_payable {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_account_payable";
    #my $i = 0;
    for my $account (@$data) {
        my $create_account_payable = "insert into $table_name ($type,year,account_type,liquidated,name,past_due_90,past_due_180,total) values (?,?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_account_payable);
        my $account_type = $account_type{$account->{account_type}};
        $dbh->pg_savepoint("account_payable");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,$account_type,@{$account}{qw/liquidated name past_due_90 past_due_180 total/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("account_payable");
            };
        }
        #say "$i accounts_payable";
        #$i++;
        $dbh->commit;
    }
    return 1;
}

sub create_loans_payable {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_loan_payable";
    for my $loan (@$data) {
        my $create_loan_payable = "insert into $table_name ($type,year,cash_repayment,loans_obtained,loans_owed_end,loans_owed_start,non_cash_repayment,source) values (?,?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_loan_payable);
        $dbh->pg_savepoint("loan_payable");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,@{$loan}{qw/cash_repayment loans_obtained loans_owed_end loans_owed_start non_cash_repayment source/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("loan_payable");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_loans_receivable {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_loan_receivable";
    for my $loan (@$data) {
        my $create_loan_receivable = "insert into $table_name ($type,year,loan_type,cash_repayments,name,new_loan_amount,non_cash_repayments,outstanding_end_amount,outstanding_start_amount,purpose,security,terms) values (?,?,?,?,?,?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_loan_receivable);
        my $loan_type = $loan_type{$loan->{loan_type}};
        $dbh->pg_savepoint("loan_receivable");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id, $year, $loan_type, @{$loan}{qw/cash_repayments name new_loan_amount non_cash_repayments outstanding_end_amount outstanding_start_amount purpose security terms/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("loan_receivable");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_investment_assets {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_investment_asset";
    for my $asset (@$data) {
        my $create_investment_asset = "insert into $table_name ($type,year,amount,name,investment_type) values (?,?,?,?,?)";
        $sth = $dbh->prepare($create_investment_asset);
        my $investment_type = $investment_type{$asset->{investment_type}};
        $dbh->pg_savepoint("investment_asset");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,@{$asset}{qw/amount name/},$investment_type);
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("investment_asset");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_other_assets {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_other_asset";
    for my $asset (@$data) {
        my $create_other_asset = "insert into $table_name ($type,year,book_value,description,value) values (?,?,?,?,?)";
        $sth = $dbh->prepare($create_other_asset);
        $dbh->pg_savepoint("other_asset");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,@{$asset}{qw/book_value description value/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("other_asset");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_fixed_assets {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id" unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type."_fixed_asset";
    for my $asset (@$data) {
        my $create_fixed_asset = "insert into $table_name ($type,year,book_value,cost_basis,depreciation,description,value) values (?,?,?,?,?,?,?)";
        $sth = $dbh->prepare($create_fixed_asset);
        $dbh->pg_savepoint("fixed_asset");
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id,$year,@{$asset}{qw/book_value cost_basis depreciation description value/});
            } catch {
                say "Could not execute: $_";
                $dbh->pg_rollback_to("fixed_asset");
            };
        }
        $dbh->commit;
    }
    return 1;
}

sub create_labor_address {
    my ($data, $id, $year) = @_;
    my $type = "labor_organization";
    #say "No id"   unless $id;
    #say "No type" unless $type;
    #say "No year" unless $year;
    my $table_name = $type . "_address";
    my $address_id = create_address({
        street_address => $data->{street_address},
        city           => $data->{city},
        state          => $data->{state},
        postal_code    => $data->{zip},
        country        => 'US'
    });
    my $labor_address_id;
    if ($address_id) {
        my $create_labor_address = "insert into $table_name ($type,address,year) values (?,?,?)";
        $sth = $dbh->prepare($create_labor_address);
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute($id, $address_id, $year);
                $labor_address_id = $dbh->last_insert_id(undef, undef, $table_name, undef);
            } catch {
                say "Could not execute: $_";
            };
        }
    }
    $dbh->commit;
    return $labor_address_id;
}

sub create_address {
    my $data = shift;
    my $address_id;
    if ($data->{street_address}) {
        my $create_address = 'insert into address (street_address,city,state,postal_code,country) values (?,?,?,?,?)';
        $sth = $dbh->prepare($create_address);
        {
            local $dbh->{RaiseError};
            try {
                $sth->execute(@{$data}{qw/street_address city state postal_code country/});
                $address_id = $dbh->last_insert_id( undef, undef, "address", undef );
            } catch {
                say "Could not execute: $_";
            };
        }
    }
    $dbh->commit;
    return $address_id;
}


#say "All done with USDOL labor organizations!";
$dbh->commit or say "Could not commit txn: ", $dbh->errstr;

1;
