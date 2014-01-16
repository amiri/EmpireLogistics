#!/usr/bin/env perl

my $path = `which perl`;
warn "Perl interp path: $path";

use Plack::Builder;
use Plack::App::File;

my $app = Plack::App::File->new(root => "/var/local/EmpireLogistics/current/root/")->to_app;

$app;

