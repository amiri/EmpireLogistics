#!/usr/bin/env perl

use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], './local');
use lib catpath((splitpath(abs_path $0))[0, 1], './lib');

use Plack::Builder;
use Plack::App::File;

my $path = `which perl`;
warn "Perl interp path: $path";
warn map { "$_ " } @INC;

my $app = Plack::App::File->new(root => catpath((splitpath(abs_path $0))[0, 1], './root'))->to_app;

$app;
