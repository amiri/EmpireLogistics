#!/usr/bin/env perl

use strict;
use warnings;
use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], '../local');
use lib catpath((splitpath(abs_path $0))[0, 1], '../lib');
use EmpireLogistics::Util::Script;
use IO::All;
use Text::CSV_XS;
use DBI;
use JSON::XS;
use Data::Printer;
use List::MoreUtils qw/any/;
use Try::Tiny;
use DateTimeX::Easy;
use URI;
require LWP::UserAgent;
use Image::Magick;
use File::Path qw(make_path remove_tree);
use DBM::Deep;
tie my %cache, 'DBM::Deep', "etc/data/photo_cache.db";

use feature qw/say/;
no warnings qw/uninitialized/;

my $dbh = EmpireLogistics::Util::Script->dbh();

my $dir = "root/images/";

my $key    = 'AIzaSyDSIgH2gnQJcK8Zz-CcRq6A_97i5qLZ1uU';
my $sensor = 'false';
my $radius = 100;
my $output = 'json';
my $base_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/$output";
my $base_photo_url = "https://maps.googleapis.com/maps/api/place/photo";

my @photo_types = qw/port rail_node warehouse/;

my %name_for_type = (
    port      => 'port_name',
    warehouse => 'name',
    rail_node => 'name',
);

my $sth;

my $ua = LWP::UserAgent->new;
$ua->timeout(5);

my $im = Image::Magick->new;

my $counter = 0;
# Loop through types
TYPE: for my $type ( sort @photo_types ) {
    my $type_dir = $dir . $type . "/";

    make_path($type_dir) unless -d $type_dir;

    my $get_command = qq{select id,$name_for_type{$type},latitude,longitude from $type};
    $sth = $dbh->prepare($get_command);

    $sth->execute or die "Could not execute statement handle: ", $sth->errstr;

    my $items = $sth->fetchall_arrayref( {} );

    # Loop through array of items of type
    ITEM: for my $item (@$items) {
        #sleep(86400) if ($counter/1000 > 1) && $counter % 1000 == 0;
        $counter++;
        my $item_name = "lat_".$item->{latitude}."_lon_".$item->{longitude};
        $item_name =~ s/\./-/g;

        say "Item: $item_name";

        my $cache_key = $type . '-' . $item_name;
        say "  Cachekey: $cache_key";

        next ITEM if defined( $cache{$cache_key}{has_photo} );

        my $uri = URI->new($base_url);
        $uri->query_form(
            location => $item->{latitude} . "," . $item->{longitude},
            sensor   => $sensor,
            key      => $key,
            radius   => $radius,
        );
        my $response = $ua->get( $uri->as_string );

        say "  Response is failure" unless $response->is_success;
        next ITEM unless $response->is_success;

        my $json;
        $json = $response->decoded_content;
        my $results = decode_json($json);

        say " Over query limit" if $results->{status} eq 'OVER_QUERY_LIMIT';
        sleep(3600) if $results->{status} eq 'OVER_QUERY_LIMIT';

        # Sleep for google
        say "  Sleeping...";
        sleep 1;


        if ($json) {
            my ($result) = grep { $_->{photos} } @{ $results->{results} };

            $cache{$cache_key}{has_photo} = 0 unless $result->{photos};

            next ITEM unless $result->{photos};

            my $photos = $result->{photos};

            $cache{$cache_key}{has_photo} = 1;

            my $photo           = $photos->[0];
            my $photo_reference = $photo->{photo_reference};
            say "  Photo reference ($type $item_name): $photo_reference";

            $cache{$cache_key}{photo_reference} = $photo_reference;

            next ITEM if $cache{$cache_key}{photo_error} == 1;

            my $photo_uri = URI->new($base_photo_url);
            $photo_uri->query_form(
                sensor         => $sensor,
                key            => $key,
                maxwidth       => 1000,
                photoreference => $photo_reference,
            );

            my $photo_response = $ua->get( $photo_uri->as_string );

            say "  Photo response is failure" unless $photo_response->is_success;
            next ITEM unless $photo_response->is_success;

            my $type_header    = $photo_response->header('content-type');

            $cache{$cache_key}{photo_error} = 1 unless $type_header =~ /image/;

            next ITEM unless $type_header =~ /image/;

            my $image = $photo_response->decoded_content( charset => 'none' );

            my $image_extension;
            $image_extension = $type_header if $type_header =~ /image/;

            $image_extension =~ s/image\///g;
            $image_extension = ".$image_extension";
            say "  Image extension: $image_extension";

            my $file_name = $item_name;
            $file_name .= $image_extension if $image_extension;

            my $image_file_dest = $type_dir . $file_name;

            say "  Saving file: $image_file_dest";
            io($image_file_dest)->print($image);

            $cache{$cache_key}{photo_file} = $image_file_dest;

            $im->Read($image_file_dest);
            my $width = $im->Get('width');
            my $height = $im->Get('height');
            my $mime_type = $type_header;
            my $caption = ucfirst($type) . " " . $item->{$name_for_type{$type}};

            my $save_media_command = "insert into media (url,mime_type,width,height,caption) values (?,?,?,?,?)";
            say "  Saving media to DB";
            $sth = $dbh->prepare($save_media_command);
            $sth->execute($image_file_dest,$mime_type,$width,$height,$caption) or die "Could not execute statement handle: ", $sth->errstr;
            $dbh->commit or die $dbh->errstr;
        }
    }
}


1;
