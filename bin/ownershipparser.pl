#!/usr/bin/env perl

use strict;
use warnings;
use IO::All;
use Data::Printer;
use JSON::XS;
use feature qw/say/;
#no warnings qw/uninitialized/;

=head2 wconv.txt

#    Railroad company abbreviations (reporting marks, carrier alpha codes)
#    as used in the CTA Railroad Network for carriers, operators, and track
#    owners.
#    Consult network documentation on deviations from official reporting marks.
#    Many dates (especially ending in zero) establish only an era, not a year.
#
#    2012 Jul 28      Bruce Peterson, ORNL, (865)946-1352
#
#         @1950 ZYX 1960@    Operated by ZYX (or successors) 1950-1960.
#         [1960 ZZ YYY  ]    Jointly owned by (or subsidiary of) ZZ & YYY.
#         %1970 ZZZ ABC %    Acquired or leased by ZZZ and ABC.
#         % ZZZ ABC 1970%    Merger (no unique ancestor).
#         %1996.5 Xd  %      Inactive after 1996 Jun, no successor.
#         ^ CR ^             Associated with (for billing).
#         #                  Comment follows.
#         *                  Any railroad.
#         RR/Div/Sub
#
#    Col   1      Flag.  H-Holding company;  A-Alias;  L-Owner/lessor.
#          3-5    AAR numeric code.
#          8-11   Reporting mark.  Always begins with an alpha character.
#                   May incl "&" if old, and a trailing number to prevent
#                   duplication.
#         13-14   Family.
#          16+    Text name, terminated by EOR or delimiter
#                   @, [, %, ^, or #.

=cut

my $directory = "data/rail/";

my $format_for_file = {
    "$directory/cta-sup/wconv.txt"  => 'A1 A4 A6 A3 A*',
};
my $families = {
    BN => "BN",
    CN => "CN",
    CP => "CP",
    CR => "CR",
    CX => "CSXT",
    GT => "Guilford",
    IC => "IC",
    KC => "KCS, TM, GWWR",
    MX => "MX",
    NS => "NS",
    SF => "ATSF",
    SP => "SP, DRGW",
    UP => "UP, MP, CNW, WP",
    WC => "WC, FVW",
    f  => "Ferry",
    n  => "Non-system/Private",
    h  => "Non-operating owner",
    o  => "Old",
    p  => "Passenger",
    r  => "Regional",
    s  => "Shortline",
    t  => "Terminal",
};
my $flags = {
    H => "Holding company",
    A => "Alias",
    L => "Owner/lessor",
};

my @files = ( "$directory/cta-sup/wconv.txt", );
my @railroads;

sub trim {
    my ($string) = @_;
    return "" unless defined $string;
    $string =~ s/^\s+|\s+$//g;
    return $string;
}

sub parsedate {
    my ($date) = @_;
    return "" unless defined $date;
    if ( $date == "0" ) {
        $date = "Indefinite past";
    } elsif ( $date =~ /(\d+)\.(\d+)/ ) {
        my $year  = $1;
        my $month = $2 + 1;
        $date = $month . '/' . $year;
    }
    return $date;
}

sub parse_owner {
    my ($owner) = @_;
    $owner = trim($owner);

    # Handle multiple ownership statements
    my @matches = ( $owner =~ m/([@\[%\^#\*].+?[@\]%\^#\*])/g );
    if ( scalar(@matches) > 1 ) {
        my @owner = map { parse_owner($_) } @matches;
        $owner = join( "; ", @owner );
    }

    #   @1950 ZYX 1960@    Operated by ZYX (or successors) 1950-1960.
    if ( $owner
        =~ /@(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?)?\s*?@/
        )
    {
        my $date1       = parsedate($1);
        my $date2       = parsedate($3);
        my $date_string = $date2 ? "($date1-$date2)" : "($date1)";
        $owner = "Operated by $2 or successors $date_string";

    #   [1960 ZZ 1970 ]    Jointly owned by (or subsidiary of) ZZ (1960-1970).
    } elsif ( $owner
        =~ /\[(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?)\s*?\]/
        )
    {
        my $date1 = parsedate($1);
        my $date2 = parsedate($3);
        $owner = "Jointly owned by (or subsidiary of) $2 ($date1-$date2)";

        #   [1960 ZZ YYY  ]    Jointly owned by (or subsidiary of) ZZ & YYY.
    } elsif ( $owner
        =~ /\[(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+)\s*?([\w\p{PosixPunct}]+)?\s*?\]/
        )
    {
        my $date1 = parsedate($1);
        $owner = "Jointly owned by (or subsidiary of) $2";
        $owner .= " and $3" if $3;
        $owner .= " ($date1)";

#   [1991 ZZ 1992 YY ]    Jointly owned by (or subsidiary of) ZZ (1991); Jointly owned by (or subsidiary of) YY (1992).
    } elsif ( $owner
        =~ /\[(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+)\s*?\]/
        )
    {
        my $date1 = parsedate($1);
        my $date2 = parsedate($3);
        $owner
            = "Jointly owned by (or subsidiary of) $2 ($date1); Jointly owned by (or subsidiary of) $4 ($date2)";

        #   [ ZZ XYZ DRU ]    Jointly owned by (or subsidiary of) ZZ.
    } elsif ( $owner
        =~ /\[\s*?([\w\p{PosixPunct}]+)\s*?([\w\p{PosixPunct}\s]+)?\s*?\]/ )
    {
        my $first      = $1;
        my $additional = $2;
        $additional = trim($additional);
        if ($additional) {
            my @additional;
            if ( $additional =~ /\w/ ) {
                @additional = split( / /, $additional );
                @additional = map { trim($_) } @additional;
                if ( scalar @additional > 1 ) {
                    $additional = join( ", ", @additional );
                } else {
                    $additional = $additional[0];
                }
            }
            $owner
                = "Jointly owned by (or subsidiary of) $first, $additional";
        } else {
            $owner = "Jointly owned by (or subsidiary of) $first";
        }

        #   %1996.5 Xd  %      Inactive after 1996 Jun, no successor.
    } elsif ( $owner =~ /%(\d{1,4}(?:\.\d+)?) Xd\s*?%/ ) {
        my $date1 = parsedate($1);
        $owner = "Inactive ($date1), no successor";

        #    %1920 YMV 1986.3 Xd%
    } elsif ( $owner
        =~ /%(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?) Xd\s*?%/
        )
    {
        my $date1 = parsedate($1);
        my $date2 = parsedate($3);
        $owner = "Owned by $2 ($date1); Inactive ($date2)";

        #    %1920 YMV 1986.3 MSRC  %
    } elsif ( $owner
        =~ /%(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+)\s*?%/
        )
    {
        my $date1 = parsedate($1);
        my $date2 = parsedate($3);
        $owner = "Owned by $2 ($date1); owned by $4 ($date2)";

        #   %0 LSMS 1977.8 LCRC 1991.1%
    } elsif ( $owner
        =~ /%(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?)\s*?%/
        )
    {
        my $date1 = parsedate($1);
        my $date2 = parsedate($3);
        my $date3 = parsedate($5);
        $owner
            = "Aquired or leased by $2 ($date1-$date2); Acquired or leased by $4 ($date3)";

     #   %0 1984 LSMS%    Acquired or leased by ZZZ from unknown time to 1984.
    } elsif ( $owner =~ /%0 (\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+)\s*?%/ )
    {
        my $date1 = "Indefinite past";
        my $date2 = parsedate($1);
        $owner = "Aquired or leased by $2";
        $owner .= " ($date1-$date2)";

        #   %0 ZZZ 1984%    Acquired or leased by ZZZ.
    } elsif ( $owner =~ /%0 ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?)\s*?%/ )
    {
        my $date1 = "Indefinite past";
        my $date2 = parsedate($2);
        $owner = "Aquired or leased by $1";
        $owner .= " ($date1-$date2)";

        # %0 OE PRTD 1994%
    } elsif ( $owner =~ /%0 ([\w\p{PosixPunct}]+) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?)\s*?%/ )
    {
        my $date1 = "Indefinite past";
        my $date2 = parsedate($3);
        $owner = "Aquired or leased by $1 and $2";
        $owner .= " ($date1-$date2)";

        #   %1970 ZZZ ABC %    Acquired or leased by ZZZ and ABC.
    } elsif ( $owner
        =~ /%(\d{1,4}(?:\.\d+)?) ([\w\p{PosixPunct}]+)\s*?([\w\p{PosixPunct}]+)?\s*?%/
        )
    {
        my $date1 = parsedate($1);
        $owner = "Aquired or leased by $2";
        $owner .= " and $3" if $3;
        $owner .= " ($date1)";

        #   % ZZZ ABC 1970%    Merger (no unique ancestor).
    } elsif ( $owner
        =~ /% ([\w\p{PosixPunct}]+) ([\w\p{PosixPunct}]+) (\d{1,4}(?:\.\d+)?)\s*?%/
        )
    {
        my $date1 = parsedate($3);
        $owner = "Merger of $1 and $2 (no unique ancestor) ($date1)";

        #   ^ CR ^             Associated with (for billing).
    } elsif ( $owner =~ /\^\s*?([\w\p{PosixPunct}]+)\s*?\^/ ) {
        $owner = "Associated with $1 for billing purposes";

        #   #                  Comment follows.
    } elsif ( $owner =~ /^# (.+?)\s*?$/ ) {
        $owner = $1;
        if ( $owner =~ /(\d{1,4}(?:\.\d+)?)/ ) {
            $owner =~ s/(\d{1,4}(?:\.\d+)?)/parsedate($1)/eg;
        }

        #   *                  Any railroad.
    } elsif ( $owner =~ /^\* (.+?)\s*?$/ ) {
        $owner = $1;
        if ( $owner =~ /(\d{1,4}(?:\.\d+)?)/ ) {
            $owner =~ s/(\d{1,4}(?:\.\d+)?)/parsedate($1)/eg;
        }
    } else {
    }
    return $owner;
}

for my $file (@files) {
    my @lines = io($file)->slurp;

    for my $line (@lines[42 .. $#lines]) {
        chomp($line);
        my $format = $format_for_file->{$file};

        my $owner;
        my ( $flag, $aar_code, $reporting_mark, $family, $name )
            = unpack( $format, $line );

        ## Trim
        ( $flag, $aar_code, $reporting_mark, $family, $name )
            = map { trim($_) }
            ( $flag, $aar_code, $reporting_mark, $family, $name );

        if ( $name =~ /^(.*?)([@\[%\^#\*].+)$/ ) {
            $name  = trim($1);
            $owner = $2;
            $owner = parse_owner($owner);
        }

        # save the original line too, which might be useful later
        push @railroads,
            {
            flag           => $flags->{$flag},
            aar_code       => $aar_code,
            reporting_mark => $reporting_mark,
            family         => $families->{$family},
            name           => $name,
            history => $owner,
            };
    }
}

my $json = JSON::XS->new->utf8->pretty->encode( \@railroads );

io("$directory/na-rail-ownership.json")->print($json);

1;
