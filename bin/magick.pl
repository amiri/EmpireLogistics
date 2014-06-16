#!/usr/bin/env perl

use strict;
use warnings;
use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], 'local');
use lib catpath((splitpath(abs_path $0))[0, 1], 'lib');
use EmpireLogistics::Util::Script;
use Imager;
use Carp::Always;
use Data::Printer;
use IO::All;

use feature qw/say/;
no warnings qw/uninitialized/;

my $file   = "test2.jpg";
my $imager = Imager->new();
warn "File exists" if -e $file;
warn abs_path($file);
my $image = $imager->read(file => abs_path($file)) or die "$!";
warn $image->type;
warn $image->tags(name => 'i_format');
$file =~ /(\.\w+)$/;
my $file_extension = $1;
my $output_file    = $file;
$output_file =~ s/$file_extension/.png/;
my $cropped = $image->crop(
    left   => 10,
    top    => 10,
    right  => 110,
    bottom => 110
);
warn "Cropped: $cropped" if $cropped;
my $x = $cropped->write(file => $output_file, type => 'png');

1;

