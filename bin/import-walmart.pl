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

sub trim {
    my ($string) = @_;
    $string =~ s/^\s+//g;
    $string =~ s/\s+$//g;
    return $string;
}

for my $key ( keys %$dcs ) {
    my $warehouse_type = $key;
    push @warehouse_types, $warehouse_type;
    my $owner = 'walmart';
    my $name = "Walmart Distribution Center";
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
        $area = undef if !$area;
        my $walmart_id;
        $walmart_id = $dc->{walmart_id} if $dc->{walmart_id};
        $walmart_id = undef if $walmart_id eq 'NA';
        my $date_opened = $dc->{date_opened};
        $date_opened = length($date_opened) ? DateTimeX::Easy->new($date_opened) : undef;
        my $geom = "$lon $lat";
        $street_address = trim($street_address);
        my $warehouse = [
            $name, $description, $status, $area, $owner, $date_opened, $lat,$lon,$walmart_id,
            {   street_address => $street_address,
                city           => $city,
                state          => $state,
                postal_code    => $postal_code,
                country        => $country
            },
            $geom,
        ];
        push @warehouses, $warehouse;
        say "    Processed Walmart warehouse ", $street_address;

        # Sleep for google.
        sleep 1;
    }
}

my $warehouse_type_command = "insert into warehouse_type (name) values (?)";
$sth = $dbh->prepare($warehouse_type_command);

for my $warehouse_type (@warehouse_types) {
    $sth->execute($warehouse_type) or die $sth->errstr;
}

my $warehouse_command
    = "insert into warehouse (name,description,status,area,owner,date_opened,latitude,longitude) values (?,?,?,?,?,?,?,?)";
$sth = $dbh->prepare($warehouse_command);

my @geoms;
my @walmarts;
my @geom_commands;
my @addresses;
for my $warehouse (@warehouses) {
    my $geom = pop @$warehouse;
    my $address = pop @$warehouse;
    my $walmart_id = pop @$warehouse;
    $sth->execute(@$warehouse) or die $sth->errstr;
    my $newid = $dbh->last_insert_id( undef, undef, "warehouse", undef );
    push @geoms, { geometry => $geom, warehouse => $newid };
    push @addresses, { address  => $address, warehouse => $newid };
    push @walmarts, { walmart_id => $walmart_id, warehouse_id => $newid } if $walmart_id;
    my ($geom_command,$walmart_command);
    my ($lon,$lat) = split(" ",$geom);
    $geom_command = "update warehouse set geometry = ST_Transform(ST_SetSRID(ST_MakePoint($lon, $lat),4326),900913) where id = $newid" if $geom =~ /\d/;
    push @geom_commands, $geom_command if $geom_command;
}

for my $walmart (@walmarts) {
    $sth = $dbh->prepare("insert into walmart (walmart_id) values (?)");
    $sth->execute($walmart->{walmart_id}) or die $sth->errstr;
    my $newid = $dbh->last_insert_id(undef, undef, 'walmart', undef);
    $sth = $dbh->prepare("insert into warehouse_walmart (walmart,warehouse) values (?,?)");
    $sth->execute($newid,$walmart->{warehouse_id}) or die $sth->errstr;
}

for my $address (@addresses) {
    my $address_insert
        = "insert into address (street_address,city,state,postal_code,country) values (?,?,?,?,?)";
    my $warehouse_address_insert
        = "insert into warehouse_address (warehouse,address) values (?,?)";
    $sth = $dbh->prepare($address_insert);
    $sth->execute( @{ $address->{address} }
            {qw/street_address city state postal_code country/} );
    my $newid = $dbh->last_insert_id( undef, undef, "address", undef );
    $sth = $dbh->prepare($warehouse_address_insert);
    $sth->execute( $address->{warehouse}, $newid );
}

for my $geom_command (@geom_commands) {
    $sth = $dbh->prepare($geom_command);
    $sth->execute();
}

$dbh->commit or die $dbh->errstr;

1;
