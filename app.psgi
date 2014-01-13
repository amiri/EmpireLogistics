#!/usr/bin/env perl

use Plack::Builder;
use Plack::App::File;

my $app = Plack::App::File->new(root => "/home/amiri/EmpireLogistics/rail_orig/")->to_app;

$app;

