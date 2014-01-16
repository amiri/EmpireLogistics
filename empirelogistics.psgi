#!/usr/bin/env perl

use local::lib catpath((splitpath(abs_path $0))[0, 1], '../local');
use lib catpath((splitpath(abs_path $0))[0, 1], '../lib');

my $path = `which perl`;
warn "Perl interp path: $path";

use Plack::Builder;
use Plack::App::File;

my $app = Plack::App::File->new(root => "/var/local/EmpireLogistics/current/root/")->to_app;

$app;

