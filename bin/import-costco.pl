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

my $dbh
    = DBI->connect( $dsn, $db_user, '3mp1r3',
    { RaiseError => 1, AutoCommit => 0 } )
    || die "Error connecting to the database: $DBI::errstr\n";

my $geocoder = Geo::Coder::Google->new( apiver => 3 );

my $dir  = "data/warehouses";
my $file = "$dir/costco.txt";

my @io  = io($file)->all;

my @warehouse_types = ("Costco Distribution Center");
my @warehouses;

for my $dc ( @io ) {
    my $owner = 'costco';
    my $name = "Costco Distribution Centers";
    my $location;
    try {
        $location = $geocoder->geocode( $dc );
    }
    catch {
        say "Couldn't geocode ", $dc, ": $_";
    };
    my ($street_number) = map { $_->{long_name} } grep {
        any {/street_number/}
        @{ $_->{types} }
    } @{ $location->{address_components} };
    my ($street) = map { $_->{long_name} } grep {
        any {/route/}
        @{ $_->{types} }
    } @{ $location->{address_components} };
    my $street_address = $street_number . " " . $street;
    my ($city) = map { $_->{long_name} } grep {
        any {/locality/}
        @{ $_->{types} }
    } @{ $location->{address_components} };
    my ($state) = map { $_->{short_name} } grep {
        any {/administrative_area_level_1/}
        @{ $_->{types} }
    } @{ $location->{address_components} };
    my ($country) = map { $_->{short_name} } grep {
        any {/country/}
        @{ $_->{types} }
    } @{ $location->{address_components} };
    my ($postal_code) = map { $_->{short_name} } grep {
        any {/postal_code/}
        @{ $_->{types} }
    } @{ $location->{address_components} };
    my $lat         = $location->{geometry}{location}{lat};
    my $lon         = $location->{geometry}{location}{lng};
    my $description;
    my $geom = "$lon $lat";
    my $warehouse = [
        $name, $street_address, $city,        $state,  $postal_code,
        $country,        $owner,       $geom,
    ];
    push @warehouses, $warehouse;
    say "    Processed Costco warehouse ", $street_address;

    # Sleep for google.
    sleep 1;

}

my $warehouse_type_command = "insert into warehouse_type (name) values (?)";
my $sth = $dbh->prepare($warehouse_type_command);

for my $warehouse_type (@warehouse_types) {
    $sth->execute($warehouse_type) or die $sth->errstr;
}

# lon     lat
#ST_GeomFromText('POINT (-6.2222 53.307)',4326)
my $warehouse_command
    = "insert into warehouse (name,street_address,city,state,postal_code,country,owner) values (?,?,?,?,?,?,?)";
$sth = $dbh->prepare($warehouse_command);

my @geom_commands;
my @geoms;
for my $warehouse (@warehouses) {
    my $geom = pop @$warehouse;
    $sth->execute(@$warehouse) or die $sth->errstr;
    my $newid = $dbh->last_insert_id( undef, undef, "warehouse", undef );
    push @geoms, { geometry => $geom, warehouse => $newid };
    my $geom_command;
    my ($lon,$lat) = split(" ",$geom);
    #$geom_command = "update warehouse set geometry = ST_GeomFromText('POINT($geom)',900913) where id = $newid" if $geom =~ /\d/;
    $geom_command = "update warehouse set geometry = ST_SetSRID(ST_MakePoint($lon, $lat),4326) where id = $newid" if $geom =~ /\d/;
    push @geom_commands, $geom_command if $geom_command;
}

for my $geom_command (@geom_commands) {
    say $geom_command;
    $sth = $dbh->prepare($geom_command);
    $sth->execute();
}

$dbh->commit or die $dbh->errstr;

1;
