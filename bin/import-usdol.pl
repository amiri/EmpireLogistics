#!/usr/bin/env perl

use strict;
use warnings;
use IO::All -utf8;
use Text::CSV_XS;
use DBI;
use JSON::XS;
use Data::Printer;
use List::MoreUtils qw/any/;
use Try::Tiny;
use DateTimeX::Easy;
use feature qw/say/;
no warnings qw/uninitialized/;

my $db_host = 'localhost';
my $db_user = 'el';
my $db_name = 'empirelogistics';

my $dsn = "dbi:Pg:dbname=$db_name;host=$db_host";

my $dbh = DBI->connect(
    $dsn, $db_user, '3mp1r3',
    {   RaiseError    => 1,
        AutoCommit    => 0,
        on_connect_do => ['set timezone = "America/Los Angeles"']
    }
) || die "Error connecting to the database: $DBI::errstr\n";

my $sth;

my $dir              = "data/labor_organizations/";
my @years            = ( 2000 .. 2013 );
my %key_for_filename = (
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
    }
);

my %union_data = ();

my %primary_key_for_rpt_id_year = ();

for my $year (@years) {
    my $subdir = $dir . $year . '/';

    for my $file_name ( keys %key_for_filename ) {
        my $file = $subdir . $file_name . $year . '.txt';
        my $io   = io($file);
        $csv->column_names( $csv->getline($io) );

        while ( my $row = $csv->getline_hr($io) ) {
            if ( $file_name eq 'lm_data_data_' ) {
                my $primary_key
                    = $row->{UNION_NAME} . ':'
                    . ( $row->{AFF_ABBR}  || '' ) . ':'
                    . ( $row->{F_NUM}     || '' ) . ':'
                    . ( $row->{FYE}       || '' ) . ':'
                    . ( $row->{UNIT_NAME} || '' );
                $primary_key_for_rpt_id_year{ $row->{RPT_ID} . '-' . $year }
                    = $primary_key;
            }
            $union_data{  $primary_key_for_rpt_id_year{ $row->{RPT_ID} . '-'
                        . $year } }{$year}{ $key_for_filename{$file_name} }
                = $row;
        }
    }
}

say p $union_data{"AIR LINE PILOTS ASN AFL-CIO:ALPA:69077:12:DELTA AIRLINES"};

1;

