#!/usr/bin/env perl

use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], './local');
use lib catpath((splitpath(abs_path $0))[0, 1], './lib');

use Plack::Builder;
use Plack::App::File;
use EmpireLogistics::Web;

warn map { "$_ " } @INC;
my $path = `which perl`;
warn "Perl interp path: $path";
warn "Perl: $^V";
warn "PERL_MB_OPT: ",  $ENV{PERL_MB_OPT};
warn "PERL_MM_OPT: ",  $ENV{PERL_MM_OPT};
warn "PERL5LIB: ",  $ENV{PERL5LIB};
warn "PATH: ",  $ENV{PATH};
warn "PERL_LOCAL_LIB_ROOT: ",  $ENV{PERL_LOCAL_LIB_ROOT};
warn "GID",  $(;
warn "EGID",  $);
warn "UID",  $<;
warn "EUID",  $>;
warn "Archname: ",  $Config::archname;

my $app = EmpireLogistics::Web->apply_default_middlewares(EmpireLogistics::Web->psgi_app(@_));

#my $app = Plack::App::File->new(root => catpath((splitpath(abs_path $0))[0, 1], './root'))->to_app;

$app;
