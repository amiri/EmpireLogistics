#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
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

my $truncate = "truncate labor_organization restart identity cascade";
$sth = $dbh->prepare($truncate);
$sth->execute or die $sth->errstr;

my $dir  = "data/labor_organizations";
my $file = "$dir/labor-organizations.json";

my $io  = io($file)->all;
my $labor_organizations = JSON::XS->new->utf8->decode($io);

my @labor_organization_types;
my @labor_organizations;

sub trim {
    my ($string) = @_;
    $string =~ s/^\s+//g;
    $string =~ s/\s+$//g;
    return $string;
}

my @affiliation_commands;

for my $labor_organization (@$labor_organizations) {
    my $insert_command = 'insert into labor_organization (name,date_established,url,organization_type,description,abbreviation) values (?,?,?,?,?,?)';
    $sth = $dbh->prepare($insert_command);
    
    my $name = $labor_organization->{name} ? $labor_organization->{name} : undef;
    my $date_established = $labor_organization->{year_established} ? DateTimeX::Easy->new(year => $labor_organization->{year_established}) : undef;
    my $members = $labor_organization->{members} ? $labor_organization->{members} : undef;
    my $url = $labor_organization->{url} ? $labor_organization->{url} : undef;
    my $organization_type = $labor_organization->{type} ? $labor_organization->{type} : undef;
    my $description = $labor_organization->{description} ? $labor_organization->{description} : undef;
    my $abbreviation = $labor_organization->{abbreviation} ? $labor_organization->{abbreviation} : undef;

    $sth->execute($name,$date_established,$url,$organization_type,$description,$abbreviation) or die "Could not execute statement handle: ", $sth->errstr;
    my $newid = $dbh->last_insert_id( undef, undef, "labor_organization", undef );
    if ($members) {
        my $members_command = 'insert into labor_organization_membership (labor_organization,members,year) values (?,?,?)';
        $sth = $dbh->prepare($members_command);
        $sth->execute($newid,$members,2013);
    }
    for my $affiliation (@{$labor_organization->{federation}}) {
        my $affiliation_command = qq{insert into labor_organization_affiliation (child,parent,year) values ($newid,(select id from labor_organization where abbreviation='$affiliation'),2013)};
        push @affiliation_commands, $affiliation_command;
    }
}

for my $affiliation_command (@affiliation_commands) {
    $sth = $dbh->prepare($affiliation_command);
    say $affiliation_command;
    $sth->execute() or die "Could not execute statement handle: ", $sth->errstr;
}

$dbh->commit or die $dbh->errstr;

1;
