#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
use Data::Printer;
use JSON::XS;
use feature qw/say/;

my $directory = "data/rail/";

my $subdiv = io("$directory/na-rail-subdivisions.json")->all;
my $subdivisions = JSON::XS->new->utf8->decode($subdiv);

my $owners = io("$directory/na-rail-ownership.json")->all;
my $ownership = JSON::XS->new->utf8->decode($owners);


my $lines = io("$directory/na-rail-lines.json")->all;
my $lines_js = JSON::XS->new->utf8->decode($lines);

for my $feature (@{$lines_js->{features}}) {
    if (exists $subdivisions->{$feature->{properties}{SB}}) {
        $feature->{properties}{SB} = $subdivisions->{$feature->{properties}{SB}};
    }
    my ($owner) = grep { $_->{reporting_mark} eq $feature->{properties}{W1} } @$ownership;
    $feature->{properties}{owner} = $owner if $owner;
}

my $json = JSON::XS->new->utf8->pretty->encode( $lines_js );

io("$directory/na-rail-lines.json")->print($json);

1;
