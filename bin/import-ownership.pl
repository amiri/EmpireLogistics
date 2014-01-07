#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
use DBI;
use JSON::XS;
use Data::Printer;
use feature qw/say/;
no warnings qw/uninitialized/;

my $db_host = 'localhost';
my $db_user = 'el';
my $db_name = 'empirelogistics';

my $dsn = "dbi:Pg:dbname=$db_name;host=$db_host";

my $dbh
    = DBI->connect( $dsn, $db_user, '3mp1r3',
    { RaiseError => 1, AutoCommit => 0 } )
    || die "Error connecting to the database: $DBI::errstr\n";


my $truncate = "truncate rail_ownership restart identity cascade";

my $sth = $dbh->prepare($truncate);
$sth->execute or die $sth->errstr;

my $dir  = "data/rail/";
my $file = "$dir/na-rail-ownership.json";

my $owners_io = io($file)->all;

my $ownership = JSON::XS->new->utf8->decode($owners_io);

my @owners = @$ownership;

my $sql_command
    = "insert into rail_ownership (aar_code,name,family,history,flag,reporting_mark) values (?,?,?,?,?,?)";

$sth = $dbh->prepare($sql_command);
for my $owner (@$ownership) {
    @{$owner}{qw/aar_code name family history flag reporting_mark/}
        = map { length($_) == 0 ? undef : $_ }
        @{$owner}{qw/aar_code name family history flag reporting_mark/};
    $sth->execute(
        @{$owner}{qw/aar_code name family history flag reporting_mark/} )
        or die $sth->errstr;
}
$dbh->commit or die $dbh->errstr;

1;
