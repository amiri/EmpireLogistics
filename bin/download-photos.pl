#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
use Text::CSV_XS;
use DBI;
use JSON::XS;
use Data::Printer;
use Geo::Coder::Google;
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

my $geocoder = Geo::Coder::Google->new( apiver => 3 );

my $dir  = "root/images/";

my $key = 'AIzaSyDSIgH2gnQJcK8Zz-CcRq6A_97i5qLZ1uU';



my $sth = $dbh->prepare($warehouse_type_command);

$dbh->commit or die $dbh->errstr;

1;
