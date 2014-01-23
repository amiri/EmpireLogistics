#!/usr/bin/env perl

use strict;
use warnings;

use Web::Scraper;
use IO::All;
use Data::Printer;
use JSON::XS;
use feature qw/say/;
use utf8;
binmode( STDOUT, ":utf8" );

my $directory = "data/warehouses/";
my $file
    = "data/warehouses/walmart.html";

sub trim {
    my ($string) = @_;
    $string =~ s/^\s+|\s+$//g;
    return $string;
}

my $html_string = io($file)->all;

$html_string =~ s/’/'/g;
$html_string =~ s/&#39;/'/g;
$html_string =~ s/&nbsp;//g;
$html_string =~ s/\x92/'/g;

my $scraper = scraper {
    process '//table[starts-with(@id, "Table")]', "tables[]" => scraper {
        process "//tbody/tr", "rows[]" => scraper {
            process "//td[1]", walmart_id => "TEXT",
            process "//td[2]", address => "TEXT",
            process "//td[3]", square_feet => "TEXT",
            process "//td[4]", date_opened => "TEXT",
            process "//td[5]/ul/li", "descriptions[]" => { text => "TEXT", };
        };
    };
};

my $tables = $scraper->scrape($html_string);
my @tables = @{ $tables->{tables} };

for my $table (@tables) {
    for my $row (@{$table->{rows}}) {
        @{$row}{qw/address square_feet walmart_id date_opened/} =
            map {trim($_)}
            @{$row}{qw/address square_feet walmart_id date_opened/};
        $row->{descriptions} = [map {trim($_->{text})} @{$row->{descriptions}}];
    }
}

my %tables;

for my $table (@tables) {
    my $header_row = shift @{ $table->{rows} };
    my $type       = $header_row->{walmart_id};
    $tables{$type} = $table->{rows};
}

my $json = JSON::XS->new->utf8->pretty->encode( \%tables );

io("$directory/walmart-distribution-centers.json")->print($json);

1;
