#!/usr/bin/env perl

use strict;
use warnings;
use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], '../local');
use lib catpath((splitpath(abs_path $0))[0, 1], '../lib');
use EmpireLogistics::Util::Script;
use Text::CSV_XS;
use Data::Printer;
use IO::All -utf8;
use feature qw/say/;


my $dir = "etc/data/";
my $file = "$dir/wp_posts.csv";

my $io = io($file);

my %rows = (
    ports => [],
    warehouses => [],
    rail => [],
);
my $csv = Text::CSV_XS->new( { binary => 1, auto_diag => 1 } );
my $cols = $csv->column_names($csv->getline($io));


while ( my $row = $csv->getline_hr($io) ) {
    if ($row->{post_name} =~ /port-/) {
        push @{$rows{ports}}, { name => $row->{post_name}, title => $row->{post_title}, content => $row->{post_content} };
    } elsif ($row->{post_name} =~ /rail/) {
        push @{$rows{rail}}, { name => $row->{post_name}, title => $row->{post_title}, content => $row->{post_content} };
    } else {
        push @{$rows{warehouses}}, { name => $row->{post_name}, title => $row->{post_title}, content => $row->{post_content} };
    }
}

1;
