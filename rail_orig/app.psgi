#!/usr/bin/env perl

use lib "/home/amiri/local/lib/perl5/site_perl/5.18.0/";
use lib "/home/amiri/local/lib/perl5/5.18.0";
use Plack::Builder;
use Plack::App::File;

my $app = Plack::App::File->new(root => "/home/amiri/EmpireLogistics/rail_orig/")->to_app;

$app;

