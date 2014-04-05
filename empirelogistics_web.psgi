#!/usr/bin/env perl

use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], './local');
use lib catpath((splitpath(abs_path $0))[0, 1], './lib');

use Plack::Builder;
use EmpireLogistics::Web;

my $app = EmpireLogistics::Web->apply_default_middlewares(EmpireLogistics::Web->psgi_app(@_));

$app;
