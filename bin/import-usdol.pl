#!/usr/bin/env perl

use strict;
use warnings;
use IO::All -utf8;
use Text::CSV_XS;
use DBI;
use JSON::XS;
use Data::Printer;
use List::MoreUtils qw/any uniq/;
use Try::Tiny;
use DateTimeX::Easy;
use Tie::IxHash;
use DBM::Deep;
use feature qw/say/;
no warnings qw/uninitialized/;

tie my %union_data, 'DBM::Deep', {
    file      => "etc/data/union_data.db",
    pack_size => 'large',
    locking   => 1,
    autoflush => 1,
};

#my $db_host = 'localhost';
#my $db_user = 'el';
#my $db_name = 'empirelogistics';

#my $dsn = "dbi:Pg:dbname=$db_name;host=$db_host";

#my $dbh = DBI->connect(
    #$dsn, $db_user, '3mp1r3',
    #{   RaiseError    => 1,
        #AutoCommit    => 0,
        #on_connect_do => ['set timezone = "America/Los Angeles"']
    #}
#) || die "Error connecting to the database: $DBI::errstr\n";

#my $sth;

my $dir   = "data/labor_organizations/";
my @years = (2000 .. 2013);

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

sub process_basic {
    my ($data) = shift;
    return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            abbreviation
            union_name
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
        = map { trim($_) } @{$data}{
        qw/
            AFF_ABBR
            UNION_NAME
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
    #return undef unless $data;
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
        = map { trim($_) } @{$data}{
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
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            account_type
            liquidated
            name
            past_due_90
            past_due_180
            total
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            ACCT_TYPE
            LIQUIDATED
            NAME
            PAST_DUE_90
            PAST_DUE_180
            TOTAL
            /
        };
    return $return;
}

sub process_fixed_assets {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            asset_type
            book_value
            cost_basis
            depreciation
            description
            value
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            ASSET_TYPE
            BOOK_VALUE
            COST_BASIS
            DEPRECIATION
            DESCRIPTION
            VALUE
            /
        };
    return $return;
}

sub process_loans_receivable {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
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
        = map { trim($_) } @{$data}{
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
    return $return;
}

sub process_investment_assets {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            amount
            investment_type
            name
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            AMOUNT
            INV_TYPE
            NAME
            /
        };
    return $return;
}

sub process_other_assets {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            book_value
            description
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            BOOK_VALUE
            DESCRIPTION
            /
        };
    return $return;
}

sub process_total_liabilities {
    my ($data) = shift;
    #return undef unless $data;
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
        = map { trim($_) } @{$data}{
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
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            account_type
            liquidated
            name
            past_due_90
            past_due_180
            total
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            ACCT_TYPE
            LIQUIDATED
            NAME
            PAST_DUE_90
            PAST_DUE_180
            TOTAL
            /
        };
    return $return;
}

sub process_loans_payable {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            cash_repayment
            loans_obtained
            loans_owed_end
            loans_owed_start
            non_cash_repayment
            source
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            CASH_REPAYMENT
            LOANS_OBTAINED
            LOANS_OWED_END
            LOANS_OWED_START
            NON_CASH_REPAYMENT
            SOURCE
            /
        };
    return $return;
}

sub process_other_liabilities {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            amount
            description
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            AMOUNT
            DESCRIPTION
            /
        };
    return $return;
}

sub process_total_receipts {
    my ($data) = shift;
    #return undef unless $data;
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
        = map { trim($_) } @{$data}{
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
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            amount_received
            book_value
            cost
            description
            gross_sales_price
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            AMOUNT_RECD
            BOOK_VALUE
            COST
            DESCRIPTION
            GROSS_SALES_PRICE
            /
        };
    return $return;
}

sub process_other_receipts {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            amount
            date
            payee
            purpose
            receipt_type
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            AMOUNT
            DATE
            PAYER_PAYEE_ID
            PURPOSE
            RECEIPT_TYPE
            /
        };
    return $return;
}

sub process_total_disbursements {
    my ($data) = shift;
    #return undef unless $data;
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
        = map { trim($_) } @{$data}{
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
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            amount
            date
            disbursement_type
            payee
            purpose
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            AMOUNT
            DATE
            DISBURSEMENT_TYPE
            PAYER_PAYEE_ID
            PURPOSE
            /
        };
    return $return;
}

sub process_investment_purchases {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            book_value
            cash_paid
            cost
            description
            investment_type
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            BOOK_VALUE
            CASH_PAID
            COST
            DESCRIPTION
            INV_TYPE
            /
        };
    return $return;
}

sub process_officer_disbursements {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
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
        = map { trim($_) } @{$data}{
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
    return $return;
}

sub process_benefits_disbursements {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            amount
            description
            paid_to
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            AMOUNT
            DESCRIPTION
            PAID_TO
            /
        };
    return $return;
}

sub process_payees {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
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
        = map { trim($_) } @{$data}{
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
    return $return;
}

sub process_dues {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            amount
            maximum
            minimum
            unit
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            AMOUNT
            MAXIMUM
            MINIMUM
            UNIT
            /
        };
    return $return;
}

sub process_membership {
    my ($data) = shift;
    #return undef unless $data;
    my $return = {};
    @{$return}{
        qw/
            category
            membership_type
            number
            voting_eligibility
            /
        }
        = map { trim($_) } @{$data}{
        qw/
            CATEGORY
            MEMBERSHIP_TYPE
            NUMBER
            VOTING_ELIGIBILITY
            /
        };
    return $return;
}

sub trim {
    my ($string) = @_;
    $string =~ s/^\s+//g;
    $string =~ s/\s+$//g;
    return $string;
}

my $csv = Text::CSV_XS->new(
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

#=head2 CREATE UNION DB

%union_data = ();

my %primary_key_for_rpt_id_year = ();

for my $year (@years) {
    my $subdir = $dir . $year . '/';

    for my $file_name ( keys %key_for_filename ) {
        my $file = $subdir . $file_name . $year . '.txt';
        my $io   = io($file);
        $csv->column_names( $csv->getline($io) );

        while (my $row = $csv->getline_hr($io)) {
            if ($file_name eq 'lm_data_data_') {
                my $primary_key = $row->{F_NUM} || ''
                    ;
                $primary_key_for_rpt_id_year{$row->{RPT_ID} . '-' . $year} =
                    $primary_key;
            }
            if ($file_name =~ /^ar/ && $file_name !~ /total/) {
                $union_data{$primary_key_for_rpt_id_year{$row->{RPT_ID}.'-'.$year}}{$year}{$key_for_filename{$file_name}} = []
                    unless $union_data{$primary_key_for_rpt_id_year{$row->{RPT_ID}.'-'.$year}}{$year}{$key_for_filename{$file_name}};
                push @{$union_data{$primary_key_for_rpt_id_year{$row->{RPT_ID}.'-'.$year}}{$year}{$key_for_filename{$file_name}}}, $row
                ;
            } else {
                $union_data{$primary_key_for_rpt_id_year{$row->{RPT_ID}.'-'.$year}}{$year}{$key_for_filename{$file_name}} = $row
                ;
            }
        }
    }
}

say p $union_data{8343};

#=cut

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

#sub collate_record_type {
    #my ($type, $keys, $data) = @_;
    #return undef unless $data;
    #my %record = ();
    #for my $key (@$keys) {
        #for my $inner_key (keys %{$data->{$key}}) {
            #if ($inner_key eq 'payee') {
                #my ($payee) = grep { $_->{payer_payee_id} = $data->{$key}{payee}} @{$data->{payees}};
                #$record{$key."_".$inner_key} = $data->{payees}{name};
                #if ($data->{payees}{payer_payee_type} == '1001') {
                    #$record{$key."_amount"} = -($data->{$key}{amount});
                #}
            #} else {
                #$record{$key."_".$inner_key} = $data->{$key}{$inner_key};
            #}
        #}
    #}
    #return \%record;
#}

#say "Number of unions: ", scalar keys %union_data;

#for my $key ((sort {$a <=> $b} keys %union_data)) {
    #next unless $key eq '8343';
    #my $union_data_for_year = $union_data{$key};
    ##for my $year (sort keys %$union_data_for_year) {
    #for my $year (@years) {
         #say "Year: $year";
         #say "Union key: $key";
         #my %record = ();
         #$record{basic} = $process{basic}->($union_data_for_year->{$year}{basic}); #if any {defined $union_data_for_year->{$year}{basic}{$_}} keys %{$union_data_for_year->{$year}{basic}};
        #say p $record{basic};

         #$record{payees} = $process{payees}->($union_data_for_year->{$year}{payees}); #if any {defined $union_data_for_year->{$year}{payees}{$_}} keys %{$union_data_for_year->{$year}{payees}};
        #say p $record{payees};

         ## Assets
         #$record{other_assets} = $process{other_assets}->($union_data_for_year->{$year}{other_assets}); #if any {defined $union_data_for_year->{$year}{other_assets}{$_}} keys %{$union_data_for_year->{$year}{other_assets}};
         #$record{total_assets} = $process{total_assets}->($union_data_for_year->{$year}{total_assets}); #if any {defined $union_data_for_year->{$year}{total_assets}{$_}} keys %{$union_data_for_year->{$year}{total_assets}};
         #$record{fixed_assets} = $process{fixed_assets}->($union_data_for_year->{$year}{fixed_assets}); #if any {defined $union_data_for_year->{$year}{fixed_assets}{$_}} keys %{$union_data_for_year->{$year}{fixed_assets}};
         #$record{investment_assets} = $process{investment_assets}->($union_data_for_year->{$year}{investment_assets}); #if any {defined $union_data_for_year->{$year}{investment_assets}{$_}} keys %{$union_data_for_year->{$year}{investment_assets}};
         #my $assets = collate_record_type('assets', [qw/investment_assets fixed_assets other_assets total_assets/],\%record);

         ## Accounts
         #$record{accounts_receivable} = $process{accounts_receivable}->($union_data_for_year->{$year}{accounts_receivable}); #if any {defined $union_data_for_year->{$year}{accounts_receivable}{$_}} keys %{$union_data_for_year->{$year}{accounts_receivable}};
         #$record{accounts_payable} = $process{accounts_payable}->($union_data_for_year->{$year}{accounts_payable}); #if any {defined $union_data_for_year->{$year}{accounts_payable}{$_}} keys %{$union_data_for_year->{$year}{accounts_payable}};
         #my $accounts = collate_record_type('accounts', [qw/accounts_payable accounts_receivable/],\%record);

         ## Loans
         #$record{loans_receivable} = $process{loans_receivable}->($union_data_for_year->{$year}{loans_receivable}); #if any {defined $union_data_for_year->{$year}{loans_receivable}{$_}} keys %{$union_data_for_year->{$year}{loans_receivable}};
         #$record{loans_payable} = $process{loans_payable}->($union_data_for_year->{$year}{loans_payable}); #if any {defined $union_data_for_year->{$year}{loans_payable}{$_}} keys %{$union_data_for_year->{$year}{loans_payable}};
         #my $loans = collate_record_type('loans', [qw/loans_payable loans_receivable/],\%record);

         ## Liabilities
         #$record{total_liabilities} = $process{total_liabilities}->($union_data_for_year->{$year}{total_liabilities}); #if any {defined $union_data_for_year->{$year}{total_liabilities}{$_}} keys %{$union_data_for_year->{$year}{total_liabilities}};
         #$record{other_liabilities} = $process{other_liabilities}->($union_data_for_year->{$year}{other_liabilities}); #if any {defined $union_data_for_year->{$year}{other_liabilities}{$_}} keys %{$union_data_for_year->{$year}{other_liabilities}};
         #my $liabilities = collate_record_type('liabilities', [qw/other_liabilities total_liabilities/],\%record);


         ## Receipts
         #$record{total_receipts} = $process{total_receipts}->($union_data_for_year->{$year}{total_receipts}); #if any {defined $union_data_for_year->{$year}{total_receipts}{$_}} keys %{$union_data_for_year->{$year}{total_receipts}};
         #$record{sales_receipts} = $process{sales_receipts}->($union_data_for_year->{$year}{sales_receipts}); #if any {defined $union_data_for_year->{$year}{sales_receipts}{$_}} keys %{$union_data_for_year->{$year}{sales_receipts}};
         #$record{other_receipts} = $process{other_receipts}->($union_data_for_year->{$year}{other_receipts}); #if any {defined $union_data_for_year->{$year}{other_receipts}{$_}} keys %{$union_data_for_year->{$year}{other_receipts}};
         #my $receipts = collate_record_type('receipts', [qw/sales_receipts other_receipts total_receipts/],\%record);


         ## Disbursements
         #$record{total_disbursements} = $process{total_disbursements}->($union_data_for_year->{$year}{total_disbursements}); #if any {defined $union_data_for_year->{$year}{total_disbursements}{$_}} keys %{$union_data_for_year->{$year}{total_disbursements}};
         #$record{general_disbursements} = $process{general_disbursements}->($union_data_for_year->{$year}{general_disbursements}); #if any {defined $union_data_for_year->{$year}{general_disbursements}{$_}} keys %{$union_data_for_year->{$year}{general_disbursements}};
         #$record{investment_purchases} = $process{investment_purchases}->($union_data_for_year->{$year}{investment_purchases}); #if any {defined $union_data_for_year->{$year}{investment_purchases}{$_}} keys %{$union_data_for_year->{$year}{investment_purchases}};
         #$record{officer_disbursements} = $process{officer_disbursements}->($union_data_for_year->{$year}{officer_disbursements}); #if any {defined $union_data_for_year->{$year}{officer_disbursements}{$_}} keys %{$union_data_for_year->{$year}{officer_disbursements}};
         #$record{benefits_disbursements} = $process{benefits_disbursements}->($union_data_for_year->{$year}{benefits_disbursements}); #if any {defined $union_data_for_year->{$year}{benefits_disbursements}{$_}} keys %{$union_data_for_year->{$year}{benefits_disbursements}};
         #$record{payees} = $process{payees}->($union_data_for_year->{$year}{payees}); #if any {defined $union_data_for_year->{$year}{payees}{$_}} keys %{$union_data_for_year->{$year}{payees}};
         #my $disbursements = collate_record_type('disbursements', [qw/officer_disbursements benefits_disbursements investment_purchases general_disbursements total_disbursements/],\%record);

         #$record{dues} = $process{dues}->($union_data_for_year->{$year}{dues}); #if any {defined $union_data_for_year->{$year}{dues}{$_}} keys %{$union_data_for_year->{$year}{dues}};
         #$record{membership} = $process{membership}->($union_data_for_year->{$year}{membership}); #if any {defined $union_data_for_year->{$year}{membership}{$_}} keys %{$union_data_for_year->{$year}{membership}};

        ## Records to make.
        ## PK is year and union id for the details.
        ##address
        ##members
        ##assets
        ##accounts
        ##disbursements
        ##receipts

        ##say p %record;
        ##say "Assets: ", p $assets;
        ##say "Accounts: ", p $accounts;
        ##say "Loans: ", p $loans;
        ##say "Liabilities: ", p $liabilities;
        ##say "Receipts: ", p $receipts;
        ##say "Disbursements: ", p $disbursements;
        ##my %finance_record = ();
        ##@finance_record{keys %$_} = values %$_ for ($assets,$accounts,$loans,$liabilities,$receipts,$disbursements);
        ##say p %finance_record;
    #}
#}

#$dbh->commit or die "Could not commit txn: ", $dbh->errstr;

1;

