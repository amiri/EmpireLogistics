#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
use DBI;
use JSON::XS;
use Data::Printer;
use Geo::Coder::Google;
use List::MoreUtils qw/any/;
use Try::Tiny;
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

my $truncate_types = "truncate warehouse_type restart identity cascade";
my $sth            = $dbh->prepare($truncate_types);
$sth->execute or die $sth->errstr;

my $truncate = "truncate warehouse restart identity cascade";
$sth = $dbh->prepare($truncate);
$sth->execute or die $sth->errstr;

my $geocoder = Geo::Coder::Google->new( apiver => 3 );

my $dir  = "data/warehouses";
my $file = "$dir/walmart-distribution-centers.json";

my $io  = io($file)->all;
my $dcs = JSON::XS->new->utf8->decode($io);

my @warehouse_types;
my @warehouses;
my @walmart_ids;

for my $key ( keys %$dcs ) {
    my $warehouse_type = $key;
    push @warehouse_types, $warehouse_type;
    my $owner = 'walmart';
    my $status;
    $status = 'closed' if $warehouse_type =~ /Closed/;
    my @dc_set = @{ $dcs->{$key} };
    for my $dc (@dc_set) {
        my $location = {};
        try {
            $location = $geocoder->geocode( $dc->{address} );
        }
        catch {
            say "Couldn't geocode ", $dc->{address}, ": $_";
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
        $description = join( '. ', @{ $dc->{descriptions} } ) if scalar(@{$dc->{descriptions}}) > 0;
        if ($description) {
            $description .= ".";
            $description =~ s/\.\.$/\./g;
            $description =~ s/\.\. /\. /g;
            $description =~ s/\s+/ /g;
        }
        my $area = $dc->{square_feet};
        $area =~ tr/0-9//cd;
        my $year_opened = $dc->{year_opened};
        $year_opened = tr/0-9//cd;
        my $geom = "$lon $lat";
        my $warehouse = [
            $street_address, $city,        $state,  $postal_code,
            $country,        $description, $status, $area,
            $owner,          $year_opened, $geom,
        ];
        push @warehouses, $warehouse;
        say "    Processed Walmart warehouse ", $dc->{address};

        # Sleep for google.
        sleep 1;
    }
}

my $warehouse_type_command = "insert into warehouse_type (name) values (?)";
$sth = $dbh->prepare($warehouse_type_command);

for my $warehouse_type (@warehouse_types) {
    $sth->execute($warehouse_type) or die $sth->errstr;
}

# lon     lat
#ST_GeomFromText('POINT (-6.2222 53.307)',4326)
my $warehouse_command
    = "insert into warehouse (street_address,city,state,postal_code,country,description,status,area,owner,year_opened) values (?,?,?,?,?,?,?,?,?,?)";
$sth = $dbh->prepare($warehouse_command);

my @geom_commands;
my @geoms;
for my $warehouse (@warehouses) {
    my $geom = pop @$warehouse;
    $sth->execute(@$warehouse) or die $sth->errstr;
    my $newid = $dbh->last_insert_id( undef, undef, "warehouse", undef );
    push @geoms, { geometry => $geom, warehouse => $newid };
    my $geom_command;
    $geom_command = "update warehouse set geometry = ST_GeomFromText('POINT($geom)',3857) where id = $newid" if $geom =~ /\d/;
    push @geom_commands, $geom_command if $geom_command;
}

for my $geom_command (@geom_commands) {
    say $geom_command;
    $sth = $dbh->prepare($geom_command);
    $sth->execute();
}

$dbh->commit or die $dbh->errstr;

1;
