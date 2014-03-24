#!/usr/bin/env perl

use strict;
use warnings;
warn map { "$_ " } @INC;
my $path = `which perl`;
warn "Perl interp path: $path";
warn "Perl: $^V";
warn "PERL_MB_OPT: ",  $ENV{PERL_MB_OPT};
warn "PERL_MM_OPT: ",  $ENV{PERL_MM_OPT};
warn "PERL5LIB: ",  $ENV{PERL5LIB};
warn "PATH: ",  $ENV{PATH};
warn "PERL_LOCAL_LIB_ROOT: ",  $ENV{PERL_LOCAL_LIB_ROOT};
warn "GID",  $(;
warn "EGID",  $);
warn "UID",  $<;
warn "EUID",  $>;
warn "Archname: ",  $Config::archname;
use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], '../local');
use lib catpath((splitpath(abs_path $0))[0, 1], '../lib');
use EmpireLogistics::Util::Script;
use IO::All;
use DBI;
use JSON::XS;
use Data::Printer;
use feature qw/say/;
no warnings qw/uninitialized/;


my $dbh = dbh();

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
