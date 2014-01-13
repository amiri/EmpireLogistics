#!/usr/bin/env perl

use Plack::Builder;
use Plack::App::File;

my $app = Plack::App::File->new(root => "root/")->to_app;

$app;

