#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
use Data::Printer;
use JSON::XS;
use feature qw/say/;

=head2 subdiv.txt 

   Since 4-character abbreviations are used for subdivision 
   identifiers in the link file, this file provides the full name of 
   the subdivision.  An attempt has been made to use unique abbre-
   viations for different subs even when the names are the same.

Fixed fields in the beginning of the record, with optional explana-
tory text:  
   Columns  Format  Name      Attribute
     1-4     A4     WMARK      Owning railroad (as ancestral as
                                 possible)
     8-11    A4     SB         Subdivision abbreviation
    14-14    A1     SBTYP      Subdivison type, subjective for now,
                                 explained in comments at the file 
                                 beginning.
    16-32    A17    SBNAME     Expanded name
    33+      A*     SBSTAT     List of states containing SB, delimited
                                 by braces, eg, {MD DE PA}.

Comments follow the closing brace.  Examples (shortened):
MP    RivM s River        {MO}  Jefferson City W> Neff Yd
MILW  Rivr s River        {MN} River Jct W 288.0 w> 407.4 St Paul Yd
SLSF  ThaS s Thayer South {MO AR TN}  Thayer > Tennessee Yd  

=cut

my $format_for_file = {

#CSXT   AAD   s Atlanta Terminal {GA}  Jones Av WA1.0 s> Spring S294.3 s> S291.5 Oakland Jct s> S288.2 East Point XXB6.4 s> XXB16.4 Stonewall
    "cta-sup/subdiv.txt" => 'A4 A7 A3 A18 A*'
};

my @files = ( "cta-sup/subdiv.txt", );

my $sbtypes = {
    d => "Lead",
    h => "Branch",
    s => "Subdivision",
    f => "Spur",
    n => "Line",
    t => "Inherited Subdivision",
};

my %subdivisions;

sub trim {
    my ($string) = @_;
    return "" unless length $string;
    $string =~ s/^\s+|\s+$//g;
    return $string;
}

sub parsestates {
    my ($string) = @_;
    $string =~ /^{(.+?)}\s*?(.+?)$/;
    my $states = $1;
    my $comments = trim($2);
    my @states = ($states && $states =~ /\w/) ? split(/ /, $states) : ();
    return (\@states,$comments);
}

my $owners = io("na-rail-ownership.json")->all;
my $ownership = JSON::XS->new->utf8->decode($owners);

for my $file (@files) {
    my @lines = io($file)->slurp;

    for my $line ( @lines[ 4 .. $#lines ] ) {
        chomp($line);
        $line = trim($line);
        next unless length $line;
        my $format = $format_for_file->{$file};

        my ( $wmark, $sb, $sbtyp, $sbname, $sbstat )
            = unpack( $format, $line );

        ## Trim
        ( $wmark, $sb, $sbtyp, $sbname, $sbstat )
            = map { trim($_) } ( $wmark, $sb, $sbtyp, $sbname, $sbstat );

        my ($states, $comment) = parsestates($sbstat);

        my ($owner) = grep { $_->{reporting_mark} eq $wmark } @$ownership;

        # save the original line too, which might be useful later
        $subdivisions{$sb} = {
            ($owner ? (owner => $owner) : ()),
            wmark => $wmark,
            type     => $sbtypes->{$sbtyp},
            name     => $sbname,
            states   => $states,
            comments => $comment,
        };
    }
}

my $json = JSON::XS->new->utf8->pretty->encode( \%subdivisions);

io("na-rail-subdivisions.json")->print($json);

1;

