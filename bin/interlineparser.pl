#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
use Data::Printer;
use JSON::XS;
use feature qw/say/;

=head2 qc28.iln 

Fields:
  (Rec) Columns Format     Name      Attribute
    (1)   2-6    A5        IIDNAM   Interline (Rule 260) junction code
    (1)   7-8    I2        IIDQ     Interline ID number
    (1)  10-13   A4        WA       Forwarding RR reporting mark
    (1)  15-38  A2,A23     NAMEA    Forwarding location (State/place)
    (1)  39-57  F10.6,F9.6 ZA       Forwarding location (lon/lat)
    (1)  59-65   I7        IJA      Forwarding RR node number
    (1)  68-72   A5        ALIAS    Alternate junction code
    (2)   2-8    F7.0      IMPED    Impedance rating
    (2)  10-13   A4        WB       Receiving RR reporting mark
    (2)  15-38  A2,A23     NAMEB    Receiving location (State/place)
    (2)  39-57  F10.6,F9.6 ZB       Receiving location (lon/lat)
    (2)  59-65   I7        IJB      Receiving RR node number
    (2)  66      A1        ITYP     Interline type
    (2)  68-71   A4        WTRM     Intermediate transfer RR

=cut

my $directory = "data/rail/";

my $format_for_file = {
#WRWCK 1 CSXT OHWARWICK                -81.64383 40.92256 3900182            300 RJCL OHWARWICK                -81.64383 40.92256 3900182
    "$directory/cta-sup/qc28.iln"  => 'A5 A2 A5 A25 A19 A8 A7 A9 A4 A25 A19 A8 A1 A5',
};

my @files = ( "$directory/cta-sup/qc28.iln", );

my @railroads;

sub trim {
    my ($string) = @_;
    $string =~ s/^\s+|\s+$//g;
    return $string;
}

sub parselatlon {
    my ($string) = @_;
    my ($lon,$lat) = split(/\s+?/, $string);
    return { lat => $lat+0, lon => $lon+0};
}

for my $file (@files) {
    my $io = io($file)->all;

    while ($io =~ /(.+?)\n(.+?)\n/gms) {
        my $line1 = $1;
        my $line2 = $2;
        my $line = $line1 . $line2;
        $line =~ s/[\n\r]//g;
        chomp($line);
        $line = trim($line);
        #say $line;
        my $format = $format_for_file->{$file};

        my ( $iidnam, $iidq, $wa, $namea, $za, $ija, $alias, $imped, $wb, $nameb, $zb, $ijb, $ityp, $wtrm )
            = unpack( $format, $line );

        ## Trim
        ( $iidnam, $iidq, $wa, $namea, $za, $ija, $alias, $imped, $wb, $nameb, $zb, $ijb, $ityp, $wtrm )
            = map { trim($_) }
        ( $iidnam, $iidq, $wa, $namea, $za, $ija, $alias, $imped, $wb, $nameb, $zb, $ijb, $ityp, $wtrm );

        $za = parselatlon($za);
        $zb = parselatlon($zb);

        # save the original line too, which might be useful later
        push @railroads, {
            type => "Feature",
            geometry => {
                type => "LineString",
                coordinates => [
                    [ $za->{lon}, $za->{lat}],
                    [ $zb->{lon}, $zb->{lat}],
                ],
            },
            properties => {
                iidname => $iidnam,
                iidq => $iidq,
                wa => $wa,
                namea => $namea,
                ija => $ija,
                alias => $alias,
                impedance => $imped,
                wb => $wb,
                nameb => $nameb,
                ijb => $ijb,
                ityp => $ityp,
                wtrm => $wtrm,
                name => $namea."-".$nameb,
                id => $ija."-".$ijb,
            },
        };
    }
}

my $feature_collection = { type => "FeatureCollection", features => \@railroads };

my $json = JSON::XS->new->utf8->pretty->encode( $feature_collection );

io("$directory/na-rail-interlines.geojson")->print($json);

1;

