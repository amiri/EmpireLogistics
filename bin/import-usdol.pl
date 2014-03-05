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
tie my %union_data, 'DBM::Deep', {
    file => "etc/data/union_data.db",
    pack_size => 'large',
    locking => 1,
    autoflush => 1,
};
use Parallel::ForkManager;
use feature qw/say/;
no warnings qw/uninitialized/;

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

my $sth;

my $dir              = "data/labor_organizations/";
my @years            = ( 2000 .. 2013 );

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
    basic => \&process_basic,
    total_assets => \&process_total_assets,
    accounts_receivable => \&process_accounts_receivable,
    fixed_assets => \&process_fixed_assets,
    loans_receivable => \&process_loans_receivable,
    investment_assets => \&process_investment_assets,
    other_assets => \&process_other_assets,
    total_liabilities => \&process_total_liabilities,
    accounts_payable => \&process_accounts_payable,
    loans_payable => \&process_loans_payable,
    other_liabilities => \&process_other_liabilities,
    total_receipts => \&process_total_receipts,
    sales_receipts => \&process_sales_receipts,
    other_receipts => \&process_other_receipts,
    total_disbursements => \&process_total_disbursements,
    general_disbursements => \&process_general_disbursements,
    investment_purchases => \&process_investment_purchases,
    officer_disbursements => \&process_officer_disbursements,
    benefits_disbursements => \&process_benefits_disbursements,
    payees => \&process_payees,
    dues => \&process_dues,
    membership => \&process_membership,
);

sub process_basic {
    my ($data) = shift;
    say "basic: ", p $data;
}

sub process_total_assets {
    my ($data) = shift;
    say "total assets: ", p $data;
}

sub process_accounts_receivable {
    my ($data) = shift;
    say "accounts receivable: ", p $data;
}

sub process_fixed_assets {
    my ($data) = shift;
    say "fixed assets: ", p $data;
}

sub process_loans_receivable {
    my ($data) = shift;
    say "loans receivable: ", p $data;
}

sub process_investment_assets {
    my ($data) = shift;
    say "investment assets: ", p $data;
}

sub process_other_assets {
    my ($data) = shift;
    say "other assets: ", p $data;
}

sub process_total_liabilities {
    my ($data) = shift;
    say "total liabilities: ", p $data;
}

sub process_accounts_payable {
    my ($data) = shift;
    say "accounts payable: ", p $data;
}

sub process_loans_payable {
    my ($data) = shift;
    say "loans payable: ", p $data;
}

sub process_other_liabilities {
    my ($data) = shift;
    say "other liabilities: ", p $data;
}

sub process_total_receipts {
    my ($data) = shift;
    say "total receipts: ", p $data;
}

sub process_sales_receipts {
    my ($data) = shift;
    say "sales receipts: ", p $data;
}

sub process_other_receipts {
    my ($data) = shift;
    say "other receipts: ", p $data;
}

sub process_total_disbursements {
    my ($data) = shift;
    say "total disbursements: ", p $data;
}

sub process_general_disbursements {
    my ($data) = shift;
    say "general disbursements: ", p $data;
}

sub process_investment_purchases {
    my ($data) = shift;
    say "investment purchases: ", p $data;
}

sub process_officer_disbursements {
    my ($data) = shift;
    say "officer disbursements: ", p $data;
}

sub process_benefits_disbursements {
    my ($data) = shift;
    say "benefits disbursements: ", p $data;
}

sub process_payees {
    my ($data) = shift;
    say "payees: ", p $data;
}

sub process_dues {
    my ($data) = shift;
    say "dues: ", p $data;
}

sub process_membership {
    my ($data) = shift;
    say "membership: ", p $data;
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

#%union_data = ();

#my %primary_key_for_rpt_id_year = ();

##my $pm = Parallel::ForkManager->new(scalar(@years));
#for my $year (@years) {
    ##$pm->start and next;
    #my $subdir = $dir . $year . '/';

    #for my $file_name ( keys %key_for_filename ) {
        #my $file = $subdir . $file_name . $year . '.txt';
        #my $io   = io($file);
        #$csv->column_names( $csv->getline($io) );

        #while (my $row = $csv->getline_hr($io)) {
            #if ($file_name eq 'lm_data_data_') {
                #my $primary_key = $row->{F_NUM};
                    ##. ':'
                    ##. ($row->{UNION_NAME} || '') . ':'
                    ##. ($row->{UNIT_NAME}  || '') . ':'
                    ##. ($row->{DESIG_NAME} || '') . ':'
                    ##. ($row->{DESIG_NUM}  || '')
                    #;
                #$primary_key_for_rpt_id_year{$row->{RPT_ID} . '-' . $year} =
                    #$primary_key;
            #}
            #$union_data{$primary_key_for_rpt_id_year{$row->{RPT_ID}.'-'.$year}}{$year}{$key_for_filename{$file_name}} = $row
            ##unless defined($union_data{$primary_key_for_rpt_id_year{$row->{RPT_ID}.'-'.$year}}{$year}{$key_for_filename{$file_name}})
            #;
        #}
    #}
    ##$pm->finish;
#}
##$pm->wait_all_children;

##say p $union_data{$_} for (keys %union_data)[0 .. 9];
##say p $union_data{69077};
##say p $union_data{"69077:AIR LINE PILOTS ASN AFL-CIO:DELTA AIRLINES:MEC:"};

say "Number of unions: ", scalar keys %union_data;
my @labor_orgs;
for my $year (@years) {
    push @labor_orgs, map { $union_data{$_}{$year}{basic}{AFF_ABBR} => trim($union_data{$_}{$year}{basic}{UNION_NAME}) } keys %union_data;
}
my %labor_orgs = @labor_orgs;
%labor_orgs = reverse %labor_orgs;
say p %labor_orgs;

#for my $key ((sort {$a <=> $b} keys %union_data)[0 .. 2]) {
    #next unless $key;    
    #my $union_data_for_year = $union_data{$key};
    #for my $year ((sort keys %$union_data_for_year)) {
         #say "Year: $year";
         #say "Union key: $key";
         #my $basic = $process{basic}->($union_data_for_year->{$year}{basic});
         #my $total_assets = $process{total_assets}->($union_data_for_year->{$year}{total_assets});
         #my $accounts_receivable = $process{accounts_receivable}->($union_data_for_year->{$year}{accounts_receivable});
         #my $fixed_assets = $process{fixed_assets}->($union_data_for_year->{$year}{fixed_assets});
         #my $loans_receivable = $process{loans_receivable}->($union_data_for_year->{$year}{loans_receivable});
         #my $investment_assets = $process{investment_assets}->($union_data_for_year->{$year}{investment_assets});
         #my $other_assets = $process{other_assets}->($union_data_for_year->{$year}{other_assets});
         #my $total_liabilities = $process{total_liabilities}->($union_data_for_year->{$year}{total_liabilities});
         #my $accounts_payable = $process{accounts_payable}->($union_data_for_year->{$year}{accounts_payable});
         #my $loans_payable = $process{loans_payable}->($union_data_for_year->{$year}{loans_payable});
         #my $other_liabilities = $process{other_liabilities}->($union_data_for_year->{$year}{other_liabilities});
         #my $total_receipts = $process{total_receipts}->($union_data_for_year->{$year}{total_receipts});
         #my $sales_receipts = $process{sales_receipts}->($union_data_for_year->{$year}{sales_receipts});
         #my $other_receipts = $process{other_receipts}->($union_data_for_year->{$year}{other_receipts});
         #my $total_disbursements = $process{total_disbursements}->($union_data_for_year->{$year}{total_disbursements});
         #my $general_disbursements = $process{general_disbursements}->($union_data_for_year->{$year}{general_disbursements});
         #my $investment_purchases = $process{investment_purchases}->($union_data_for_year->{$year}{investment_purchases});
         #my $officer_disbursements = $process{officer_disbursements}->($union_data_for_year->{$year}{officer_disbursements});
         #my $benefits_disbursements = $process{benefits_disbursements}->($union_data_for_year->{$year}{benefits_disbursements});
         #my $payees = $process{payees}->($union_data_for_year->{$year}{payees});
         #my $dues = $process{dues}->($union_data_for_year->{$year}{dues});
         #my $membership = $process{membership}->($union_data_for_year->{$year}{membership});
    #}
#}

1;

