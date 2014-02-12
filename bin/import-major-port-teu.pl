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

my $dir  = "data/ports";
my $file = "$dir/ports_major.json";

my $io    = io($file)->all;
my $ports = JSON::XS->new->utf8->decode($io);

my %major_ports = ();

for my $port ( @{ $ports->{features} } ) {
    my $name = $port->{properties}{PORT_NAME};
    $name =~ s/(, \w+)//g;
    $major_ports{$name} = {
        properties  => $port->{properties},
        coordinates => $port->{geometry}{coordinates}
    };
}

my $sth;

for my $port_name ( keys %major_ports ) {
    next if $port_name eq 'Southeast Missouri Port';
    next if $port_name eq 'Port Dolomite';
    next if $port_name eq 'Penn Manor';
    next if $port_name eq 'Greenville';
    next if $port_name eq 'Taconite';
    next if $port_name eq 'Lake Providence';

    # Some heuristics to hit the right port
    my $short_name = $port_name;
    $short_name = "Detroit"       if $port_name eq 'Detroit';
    $short_name = "Port Lavaca"   if $port_name eq 'Matagorda Port Lv Pt Com';
    $short_name = "Duluth"        if $port_name eq 'Duluth-Superior and WI';
    $short_name = "New York City" if $port_name eq 'New York and NJ';
    $short_name = "Unalaska"      if $port_name eq 'Unalaska Island';
    $short_name = "St Clair"      if $port_name eq 'St. Clair';
    $short_name = "Morgan City"   if $port_name eq 'Morgan City of';
    $short_name = "St Louis"      if $port_name eq 'St. Louis and IL';
    $short_name = "Fairport"      if $port_name eq 'Fairport Harbor';
    $short_name = "Camden"        if $port_name eq 'Camden-Gloucester';
    $short_name = "Port Aransas"  if $port_name eq 'Aransas Pass';
    $short_name = "Port Sulphur"  if $port_name eq 'Plaquemines of';
    $short_name = "Kawaihae"      if $port_name eq 'Kawaihae Harbor';
    $short_name = "Nikiski"       if $port_name eq 'Nikishka';

    # Identify the port in question
    my $id_command = qq{SELECT id,port_name FROM port };
    $id_command .= qq{WHERE port_name ILIKE '%$short_name%' };
    $id_command
        .= qq{ORDER BY ST_Distance(ST_Transform(ST_GeomFromText('POINT(};
    $id_command .= $major_ports{$port_name}->{coordinates}[0];
    $id_command .= " ";
    $id_command .= $major_ports{$port_name}->{coordinates}[1];
    $id_command .= qq{)',4326),900913), geometry) ASC limit 1};

    # Get the port id and name
    $sth = $dbh->prepare($id_command);
    $sth->execute;
    my $port = $sth->fetchall_arrayref( {} );
    next unless $port->[0]->{id};

    say "Updating ", $port->[0]->{port_name};

    my $update_command
        = "update port set domestic_tonnage = ?, foreign_tonnage = ?, import_tonnage = ?, export_tonnage = ?, total_tonnage = ? where id = ?";
    $sth = $dbh->prepare($update_command);
    $sth->execute(
        @{ $major_ports{$port_name}{properties} }
            {qw/DOMESTIC FOREIGN IMPORTS EXPORTS TOTAL/},
        $port->[0]->{id}
    ) or die $sth->errstr;
}

# Commit
$dbh->commit or die $dbh->errstr;

1;
