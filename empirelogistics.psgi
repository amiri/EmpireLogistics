#!/usr/bin/env perl

use Plack::Builder;
use Plack::App::File;

my $app = Plack::App::File->new(root => "/var/local/EmpireLogistics/current/root/")->to_app;

$app;

