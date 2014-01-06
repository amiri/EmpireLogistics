#!/usr/bin/env perl 

use strict;
use warnings;
use IO::All;
use DBI;
use JSON::XS;
use Data::Printer;
use List::MoreUtils qw/uniq/;
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

# Truncate subdivisions
my $truncate_subdiv = "truncate subdivisions restart identity cascade";

my $sth = $dbh->prepare($truncate_subdiv);
$sth->execute or die $sth->errstr;

my $dir  = "data/rail";
my $file = "$dir/na-rail-subdivisions.json";

my $io      = io($file)->all;
my $subdivs = JSON::XS->new->utf8->decode($io);
my %subdivs = %$subdivs;

my %subdivisions_states = map { $_ => $subdivs{$_}->{states} } grep {
    exists $subdivs{$_}->{states}
        && scalar( @{ $subdivs{$_}->{states} } )
        > 0
} keys %subdivs;

# Populate subdivisions
my $sql_command
    = "insert into subdivisions (name,full_name,wmark,subdivision_type,comments) values (?,?,?,?,?)";

$sth = $dbh->prepare($sql_command);

while ( my ( $name, $subdiv ) = each %subdivs ) {
    my $record = {};
    $record->{name} = $name;
    @{$record}{qw/full_name wmark subdivision_type comments/}
        = map { length($_) == 0 ? undef : $_ }
        @{$subdiv}{qw/name wmark type comments/};
    $sth->execute(
        @{$record}{qw/name full_name wmark subdivision_type comments/} )
        or die $sth->errstr;
}

# Truncate states
my $truncate_states = "truncate states restart identity cascade";
$sth = $dbh->prepare($truncate_states);
$sth->execute or die $sth->errstr;

# Populate states
my $states_command = "insert into states (abbreviation) values (?)";

my @states;
for my $sub_name ( keys %subdivisions_states ) {
    my @sub_states = @{ $subdivisions_states{$sub_name} };
    push @states, @sub_states;
}

@states = uniq sort @states;

$sth = $dbh->prepare($states_command);
$sth->execute($_) for @states;

# Truncate rels
my $truncate_rels = "truncate subdivisions_states cascade";
$sth = $dbh->prepare($truncate_rels);
$sth->execute or die $sth->errstr;

# Populate rels
my $rels_command
    = "insert into subdivisions_states (subdivision, state) values ((select id from subdivisions where name = ?),(select id from states where abbreviation = ?))";
$sth = $dbh->prepare($rels_command);

for my $sub_name ( keys %subdivisions_states ) {
    my @sub_states = @{ $subdivisions_states{$sub_name} };
    for my $sub_state (@sub_states) {
        $sth->execute( $sub_name, $sub_state ) or die $sth->errstr;
    }
}

# Commit
$dbh->commit or die $dbh->errstr;

1;
