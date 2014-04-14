#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath( ( splitpath( abs_path $0) )[ 0, 1 ], '../local' );
use lib catpath( ( splitpath( abs_path $0) )[ 0, 1 ], '../lib' );
use EmpireLogistics::Util::Script;
use Path::Class;
use IO::All;
use Moose;
use MooseX::Types::Path::Class;

with 'MooseX::Getopt';

has 'origin' => (
    is       => 'rw',
    isa      => 'Path::Class::Dir',
    required => 1,
    coerce   => 1,
    default  => "lib/EmpireLogistics/Schema/Result",
);

has 'destination' => (
    is       => 'rw',
    isa      => 'Path::Class::Dir',
    required => 1,
    coerce   => 1,
    default  => "lib/EmpireLogistics/Form/Admin",
);

has 'schema_name' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => 'EmpireLogistics::Schema',
);

has 'dsn' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'dbi:Pg:dbname=empireLogistics',
);

has 'dbuser' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'el',
);
has 'dbpass' => (
    is  => 'ro',
    isa => 'Str',
);

sub run {
    my ($self) = @_;
    for my $child ( $self->origin->children ) {
        next if $child eq 'lib/EmpireLogistics/Schema/Result/User.pm';
        print "Resultset: $child\n";
        ( my $filename = $child ) =~ s/^.*\///g;
        ( my $rsname   = $filename ) =~ s/\.pm//g;
        my $modulename  = $rsname . '.pm';
        my $formname    = $rsname;
        my $schema      = $self->schema_name;
        my $destination = $self->destination;
        my $dbuser      = $self->dbuser;
        my $dbpass      = $self->dbpass;
        my $dsn         = $self->dsn;

        print
            "form_generator.pl --rs_name=$rsname --schema_name=$schema --db_dsn=$dsn --db_user=$dbuser > $destination/$filename\n";
        system(
            "form_generator.pl --rs_name=$rsname --schema_name=$schema --db_dsn=$dsn --db_user=$dbuser > $destination/$modulename"
        );
        my $content = io("$destination/$modulename")->slurp;
        if ( $content =~ /package/ ) {
            s/package ($formname)/package EmpireLogistics::Form::Admin::$1/g;
        }
    }
    $content > io("$destination/$modulename");
}
}

__PACKAGE__->meta->make_immutable;
__PACKAGE__->new_with_options->run unless caller;

1;
