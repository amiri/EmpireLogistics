#!/usr/bin/env perl

use strict;
use warnings;
use Cwd 'abs_path';
use File::Spec::Functions qw(catpath splitpath);
use local::lib catpath((splitpath(abs_path $0))[0, 1], '../local');
use lib catpath((splitpath(abs_path $0))[0, 1], '../lib');
use EmpireLogistics::Util::Script;

use Web::Scraper;
use IO::All -utf8;
use Data::Printer;
use JSON::XS;
use List::MoreUtils qw/part none/;
use feature qw/say/;
use utf8;
binmode( STDOUT, ":utf8" );

my $directory = "data/labor_organizations/";
my $file      = "data/labor_organizations/labor_organizations.html";

sub trim {
    my ($string) = @_;
    $string =~ s/^\s+|\s+$//g;
    return $string;
}

sub rename_and_process {
    my ($unions) = @_;
    my @unions = @$unions;
    for my $union (@unions) {
        if ($union->{name} eq 'United Independent Technology Technicians Of America' && !defined($union->{federation})) {
            $union = undef;
            next;
        }
        if ($union->{name} eq 'United Brotherhood of Carpenters and Joiners of America' && !defined($union->{year_established})) {
            $union = undef;
            next;
        }
        if ($union->{name} eq
            "National Education Association of the United States")
        {
            $union->{federation}   = ['EI'];
            $union->{abbreviation} = 'NEA';
        }
        if ($union->{name} eq "National Education Association") {
            $union = undef;
            next;
        }

        if ($union->{name} eq "Service Employees International Union") {
            $union->{federation} = ['CTW', 'CLC'];
            $union->{abbreviation} = 'SEIU';
        }

        if ($union->{name} eq
            "American Federation of State, County, and Municipal Employees")
        {
            $union->{federation}   = ['AFL-CIO'];
            $union->{abbreviation} = 'AFSCME';
        }
        if ($union->{name} eq
            "American Federation of State, County, and Municipal Employees")
        {
            $union->{federation}   = ['AFL-CIO'];
            $union->{abbreviation} = 'AFSCME';
        }
        if ($union->{name} eq
            "American Federation of State, County and Municipal Employees")
        {
            $union = undef;
            next;
        }

        if ($union->{name} eq "Teamsters") {
            $union->{federation} = ['CTW', 'CLC'];
            $union->{abbreviation} = 'IBT';
        }

        if ($union->{name} eq "United Food and Commercial Workers" && !defined($union->{year_established})) {
            $union = undef;
            next;
        }
        if ($union->{name} eq "United Food and Commercial Workers") {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'UFCW';
        }

        if ($union->{name} eq "American Federation of Teachers") {
            $union->{federation} = ['AFL-CIO', 'EI'];
            $union->{abbreviation} = 'AFT';
        }

        if ($union->{name} eq 'United Steel, Paper and Forestry, Rubber, Manufacturing, Energy, Allied Industrial and Service Workers International Union' && !defined($union->{members})) {
            $union = undef;
            next;
        }
        if ($union->{name} eq "United Steelworkers") {
            $union->{name} = 'United Steel, Paper and Forestry, Rubber, Manufacturing, Energy, Allied Industrial and Service Workers International Union';
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'USWA';
        }

        if ($union->{name} eq
            "International Brotherhood of Electrical Workers")
        {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'IBEW';
        }

        if ($union->{name} eq
            "Laborers’ International Union of North America")
        {
            $union->{federation}   = ['AFL-CIO'];
            $union->{abbreviation} = 'LIUNA';
        }

        if ($union->{name} eq
            "International Association of Machinists and Aerospace Workers")
        {
            $union->{federation} = ['AFL-CIO', 'CLC', 'ITF'];
            $union->{abbreviation} = 'IAM';
        }

        if ($union->{name} eq "United Auto Workers") {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'UAW';
        }

        if ($union->{name} eq "Communications Workers of America") {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'CWA';
        }

        if ($union->{name} eq
            "United Brotherhood of Carpenters and Joiners of America")
        {
            $union->{federation}   = ['CLC'];
            $union->{abbreviation} = 'CJA';
        }

        if ($union->{name} eq
            "Union of Needletrades, Industrial, and Textile Employees")
        {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'UNITE';
        }

        if ($union->{name} eq "International Longshore and Warehouse Union")
        {
            $union->{federation}   = ['CLC'];
            $union->{abbreviation} = 'ILWU';
        }

        if ($union->{name} eq "International Union of Operating Engineers")
        {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'IUOE';
        }

        if ($union->{name} eq
            "United Association of Journeymen and Apprentices of the Plumbing, Pipefitting and Sprinkler Fitting Industry of the United States and Canada"
            )
        {
            $union = undef;
            next;
        }

        if ($union->{name} eq "United Association") {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'UA';
            $union->{name} =
                'United Association of Journeymen and Apprentices of the Plumbing, Pipefitting and Sprinkler Fitting Industry of the United States and Canada';
        }

        if ($union->{name} eq "National Association of Letter Carriers") {
            $union->{federation} = ['AFL-CIO', 'UNI'];
            $union->{abbreviation} = 'NALC';
        }

        if ($union->{name} eq "American Postal Workers Union") {
            $union->{federation} = ['AFL-CIO', 'UNI'];
            $union->{abbreviation} = 'APWU';
        }

        if ($union->{name} eq "International Association of Fire Fighters")
        {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'IAFF';
        }

        if ($union->{name} eq "National Postal Mail Handlers Union") {
            $union->{federation}   = ['AFL-CIO'];
            $union->{abbreviation} = 'NPMHU';
        }

        if ($union->{name} eq "American Federation of Government Employees")
        {
            $union->{federation}   = ['AFL-CIO'];
            $union->{abbreviation} = 'AFGE';
        }

        if ($union->{name} eq "Amalgamated Transit Union") {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'ATU';
        }

        if ($union->{name} eq "American Nurses Association") {
            $union->{federation}   = [];
            $union->{abbreviation} = 'ANA';
        }

        if ($union->{name} eq
            "Sheet Metal Workers International Association")
        {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'SMW';
        }

        if ($union->{name} eq
            "International Union of Painters and Allied Trades")
        {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'IUPAT';
        }

        if ($union->{name} eq
            "International Association of Bridge, Structural, Ornamental and Reinforcing Iron Workers"
            )
        {
            $union = undef;
            next;
        }

        if ($union->{name} eq
            "International Association of Bridge, Structural, Ornamental, and Reinforcing Iron Workers"
            )
        {
            $union->{federation} = ['AFL-CIO', 'CLC'];
            $union->{abbreviation} = 'BSOIW';
        }

        if ($union->{name} eq "Transport Workers Union of America") {
            $union->{federation}   = ['AFL-CIO'];
            $union->{abbreviation} = 'TWU';
        }

        if ($union->{name} eq
            "American Association of Classified School Employees")
        {
            $union->{federation}   = [];
            $union->{abbreviation} = 'AACSE';
        }

        if ($union->{name} eq "National Rural Letter Carriers Association")
        {
            $union = undef;
            next;
        }
        if ($union->{name} eq "National Rural Letter Carriers' Association")
        {
            $union->{federation}   = [];
            $union->{abbreviation} = 'NRLCA';
        }
        if ($union->{name} eq
            "International Union Security * Police * Fire Professionals of America"
            )
        {
            $union->{name} =
                'International Union, Security, Police and Fire Professionals of America';
            $union->{abbreviation} = 'SPFPA';
        }
        if ($union->{name} eq
            "Writers Guild of America, west"
            )
        {
            $union->{name} =
                'Writers Guild of America, West';
        }
    }

    return [grep {$_} @unions];
}

my $html_string = io($file)->all;

$html_string =~ s/’/'/g;
$html_string =~ s/&#39;/'/g;
$html_string =~ s/&nbsp;//g;
$html_string =~ s/\x92/'/g;

my @federations = (
    {   name =>
            'American Federation of Labor-Congress of Industrial Organizations',
        abbreviation     => 'AFL-CIO',
        members          => 11525023,
        url              => 'http://aflcio.org/',
        type             => 'federation',
        year_established => 1955,
        description =>
            "The American Federation of Labor and Congress of Industrial Organizations (AFL–CIO) is a national trade union center, the largest federation of unions in the United States, made up of fifty-seven national and international unions, together representing more than 11 million workers (as of June 2008, the most recent official statistic). It was formed in 1955 when the AFL and the CIO merged after a long estrangement. From 1955 until 2005, the AFL–CIO's member unions represented nearly all unionized workers in the United States. Several large unions split away from AFL–CIO and formed the rival Change to Win Federation in 2005 but several unions have since reaffiliated. The largest union currently in the AFL–CIO is the American Federation of State, County and Municipal Employees (AFSCME), with more than 1.6 million members.",
    },
    {   name             => 'Change to Win Federation',
        abbreviation     => 'CTW',
        members          => 4250811,
        url              => 'http://www.changetowin.org/',
        type             => 'federation',
        year_established => 2005,
        description =>
            "The Change to Win Federation (CtW) is a coalition of American labor unions originally formed in 2005 as an alternative to the AFL-CIO. The coalition is associated with strong advocacy of the organizing model. The coalition currently consists of three member unions: The International Brotherhood of Teamsters (IBT); Service Employees International Union (SEIU); and United Farm Workers (UFW).",
    },
    {   name             => 'Canadian Labour Congress',
        abbreviation     => 'CLC',
        members          => 3300000,
        type             => 'federation',
        url              => 'http://www.clc-ctc.ca/',
        year_established => 1956,
        description =>
            'The Canadian Labour Congress, or CLC (in French "le Congrès du travail du Canada" or CTC) is a national trade union centre, the central labour body in English Canada to which most Canadian labour unions are affiliated.',
    },
    {   name             => 'Education International',
        abbreviation     => 'EI',
        members          => 30000000,
        type             => 'federation',
        url              => 'http://www.ei-ie.org/',
        year_established => 1993,
        description =>
            "Education International (EI-IE) is a global union federation of teachers' trade unions. Currently, it has 401 member organizations in 172 countries and territories, representing over 30 million education personnel from pre-school to university. This makes it the world's largest sectorial global union federation.",
    },
    {   name             => "International Transport Workers' Federation",
        abbreviation     => 'ITF',
        members          => 5000000,
        type             => 'federation',
        url              => 'http://www.itfglobal.org/',
        year_established => 1896,
        description =>
            "The International Transport Workers' Federation (ITF) is a global union federation of transport workers' trade unions, founded in 1896. In 2009 the ITF had 654 member organizations in 148 countries, representing a combined membership of 4.5 million workers.",
    },
    {   name             => "IndustriALL Global Union",
        abbreviation     => 'IGU',
        members          => 50000000,
        url              => 'http://www.industriall-union.org/',
        type             => 'federation',
        year_established => 2012,
        description =>
            "IndustriALL Global Union is a global union federation, founded in Copenhagen on 19 June 2012. In 2012 IndustriALL Global Union represented more than 50 million working people of 140 countries working in different sectors.",
    },
    {   name             => "UNI Global Union",
        abbreviation     => 'UNI',
        members          => 20000000,
        url              => 'http://www.uniglobalunion.org/',
        year_established => 2000,
        type             => 'federation',
        description =>
            "UNI Global Union is a global union federation for skills and services, gathering national and regional trade unions. It was launched on January 1, 2000, as Union Network International. Its more than 900 affiliated unions in 140 countries have 20 million members. The head office is in Nyon, near Geneva, Switzerland.",
    },
);

my $scraper = scraper {
    process '//table/tbody/tr', "largest[]" => scraper {
        process "//td[2]",
            name => "TEXT",
            process "//td[3]",
            year_established => "TEXT",
            process "//td[4]", members => sub {
            my $elem = shift;
            my $text = $elem->as_text;
            $text =~ s/\D//g;
            return trim($text);
            },
            process "//td[5]",
            description => "TEXT",
            process "//td[7]/a",
            "url" => '@href',
            ;
    };
};

my $largest_unions = $scraper->scrape($html_string);
$largest_unions->{largest} = rename_and_process($largest_unions->{largest});

my $scraper2 = scraper {
    process '//div[@id="mw-content-text"]/ul[1]/li', "aflcio[]" => scraper {
        process "li>a",
            name => "TEXT",
            process "//ul/li", "unions[]" => scraper {
            process "li",
                name => "TEXT",
                ;
            },
            ;
    };
};

my $aflcio = $scraper2->scrape($html_string);
$aflcio->{aflcio} = rename_and_process($aflcio->{aflcio});

my $scraper3 = scraper {
    process '//div[@id="mw-content-text"]/ul[2]/li', "ctw[]" => scraper {
        process "li>a",
            name => "TEXT",
            process "//ul/li", "unions[]" => scraper {
            process "li",
                name => "TEXT",
                ;
            },
            ;
    };
};

my $ctw = $scraper3->scrape($html_string);
$ctw->{ctw} = rename_and_process($ctw->{ctw});

my $scraper4 = scraper {
    process '//div[@id="mw-content-text"]/ul[3]/li', "indy[]" => scraper {
        process "li>a",
            name => "TEXT",
            process "//ul/li", "unions[]" => scraper {
            process "li",
                name => "TEXT",
                ;
            },
            ;
    };
};

my $indy = $scraper4->scrape($html_string);
$indy->{indy} = rename_and_process($indy->{indy});

my $scraper5 = scraper {
    process '//div[@id="mw-content-text"]/ul[4]/li', "reform[]" => scraper {
        process "li>a",
            name => "TEXT",
            process "//ul/li", "unions[]" => scraper {
            process "li",
                name => "TEXT",
                ;
            },
            ;
    };
};

my $reform = $scraper5->scrape($html_string);

my @largest_names = map { $_->{name} } @{ $largest_unions->{largest} };
# Make sure each of the CTW and AFL-CIO unions has its proper federation set.
# And take out records that duplicate the largest unions.
@{ $ctw->{ctw} } = map {
    $_->{federation} = ['CTW']; $_
} grep {
    defined $_->{name}
} @{ $ctw->{ctw} };

@{ $aflcio->{aflcio} } = grep {
    my $afl = $_;
    none { $afl->{name} eq $_ } @largest_names
} map {
    $_->{federation} = ['AFL-CIO'];
    $_
} grep {
    defined $_->{name}
} @{ $aflcio->{aflcio} };

@{ $reform->{reform} } = map {
    $_->{type} = 'reform'; $_
} grep {
    defined $_->{name}
} @{ $reform->{reform} };

@{ $largest_unions->{largest} } = grep {
    defined $_->{name}
} @{ $largest_unions->{largest} };

# Put all the unions into one array.
my @unions = (
    @{ $largest_unions->{largest} },
    @{ $aflcio->{aflcio} },
    @{ $ctw->{ctw} },
    @{ $indy->{indy} },
    @{ $reform->{reform} },
);

# Split unions into those with subunions
my @part = part { exists( $_->{unions} ) } @unions;

my @normal_unions  = @{ $part[0] };
my @subfederations = @{ $part[1] };

# For each of those unions with subunions, take the subunions,
# give each one a federation from the parent, and push each subunion
# into the big unions array
for my $subfederation (@subfederations) {
    my $unions = delete $subfederation->{unions};
    my $federation
        = $subfederation->{name} eq 'International Brotherhood of Teamsters'
        ? 'IBT'
        : $subfederation->{name} eq 'Service Employees International Union'
        ? 'SEIU'
        : $subfederation->{name} eq
        'Associated Actors and Artistes of America' ? 'AAA'
        : '';
    @$unions = map { $_->{federation} = [$federation]; $_ } grep {$_} @$unions;
    push @normal_unions, @$unions;
}

# Delete IBT and SEIU from subfederations, because we have proper, full
# data for them in the unions array already. We will copy that into
# the federations.
@subfederations = grep { $_->{name} !~ /Teamsters|Service/ } @subfederations;

# Set AAA's abbreviation.
$subfederations[0]->{abbreviation} = 'AAA';
$subfederations[0]->{type}         = 'hybrid';

# Put AAA into the federations array.
push @federations, @subfederations;

# Grab the full IBT and SEIU data from the unions array.
my @federation_parts = part {
    exists( $_->{abbreviation} ) && $_->{abbreviation} =~ /(IBT|SEIU)/;
}
@normal_unions;

my @filtered_unions      = @{ $federation_parts[0] };
my @filtered_federations = @{ $federation_parts[1] };

@filtered_federations
    = map { $_->{type} = 'hybrid'; $_ } @filtered_federations;

# Put the full IBT and SEIU data into the federations array.
push @federations, @filtered_federations;

@filtered_unions = map { $_->{type} = 'union' unless $_->{type}; $_ } @filtered_unions;

my @all_organizations = ( @federations, @filtered_unions );

my %abbreviations = (
    "Actors' Equity Association"                          => "AEA",
    "Air Line Pilots Association"                         => "ALPA",
    "Aircraft Mechanics Fraternal Association"            => "FAAM",
    "Amalgamated Transit Union"                           => "ATU",
    "American Association of Classified School Employees" => "AACSE",
    "American Federation of Government Employees"         => "AFGE",
    "American Federation of Musicians"                    => "AFM",
    "American Federation of School Administrators"        => "AFSA",
    "American Federation of State, County and Municipal Employees" =>
        "AFSCME",
    "American Federation of Teachers"       => "AFT",
    "American Guild of Musical Artists"     => "AGMA",
    "American Guild of Variety Artists"     => "AGVA",
    "American Postal Workers Union"         => "APWU",
    "American Train Dispatchers Department" => "ATDD",
    "Bakery, Confectionery, Tobacco Workers and Grain Millers' International Union"
        => "BCTGMI",
    "Brotherhood of Railroad Signalmen"                         => "BRS",
    "California Nurses Association"                             => "CNA",
    "California School Employees Association"                   => "CSEA",
    "Coalition of Graduate Employee Unions"                     => "CGEU",
    "Colorado Workers for Innovations and New Solutions (WINS)" => "WINS",
    "Communications Workers of America"                         => "CWA",
    "Directors Guild of America"                                => "DGA",
    "Dramatists Guild of America"         => "Dramatists",
    "Farm Labor Organizing Committee"     => "FLOC",
    "Federation of Professional Athletes" => "FPA",
    "Fraternal Order of Police"           => "FOP",
    "Glass, Molders, Pottery, Plastics and Allied Workers International Union"
        => "GMP",
    "Graphic Communications Conference (GCC)"              => "GCIU",
    "Independent Pilots Association"                       => "IPA",
    "Industrial Workers of the World"                      => "IWW",
    "International Alliance of Theatrical Stage Employees" => "IATSE",
    "International Association of Bridge, Structural, Ornamental, and Reinforcing Iron Workers"
        => "BSOIW",
    "International Association of Fire Fighters" => "IAFF",
    "International Association of Heat and Frost Insulators and Asbestos Workers"
        => "HFIA",
    "International Association of Machinists and Aerospace Workers" => "IAM",
    "International Brotherhood of Boilermakers, Iron Ship Builders, Blacksmiths, Forgers and Helpers"
        => "BBF",
    "International Brotherhood of Electrical Workers" => "IBEW",
    "International Federation of Professional and Technical Engineers" =>
        "IFPTE",
    "International Guards Union of America"       => "GUA",
    "International Longshore and Warehouse Union" => "ILWU",
    "International Longshoremen's Association"    => "ILA",
    "International Plate Printers, Die Stampers and Engravers Union of North America"
        => "PPDSE",
    "International Union Security * Police * Fire Professionals of America"
        => "SPFPA",
    "International Union of Allied Novelty and Production Workers" => "NPW",
    "International Union of Bricklayers and Allied Craftworkers"   => "BAC",
    "International Union of Elevator Constructors"                 => "IUEC",
    "International Union of Journeymen and Allied Trades"          => "IUJAT",
    "International Union of Operating Engineers"                   => "IUOE",
    "International Union of Painters and Allied Trades"            => "IUPAT",
    "International Union of Police Associations"                   => "IUPA",
    "Jockeys' Guild"                                        => "Jockeys",
    "Labor Notes"                                           => undef,
    "Laborers' International Union of North America"        => "LIUNA",
    "Laborers' International Union of North America"        => "LIUNA",
    "Major League Baseball Players Association"             => "MLBPA",
    "Marine Engineers Beneficial Association"               => "MEBA",
    "NHL Players Association"                               => "NHLPA",
    "National Air Traffic Controllers Association"          => "NATCA",
    "National Association of Letter Carriers"               => "NALC",
    "National Basketball Players Association"               => "NBPA",
    "National Education Association"                        => "NEA",
    "National Emergency Medical Services Association"       => "NEMSA",
    "National Football League Players Association"          => "NFLPA",
    "National Rural Letter Carriers Association"            => "RLCA",
    "National Treasury Employees Union"                     => "NTEU",
    "National Weather Service Employees Organization"       => "NWSEO",
    "Office and Professional Employees International Union" => "OPEIU",
    "Operative Plasterers' and Cement Masons' International Association" =>
        "OPCM",
    "Patrolmen's Benevolent Association"             => "PBA",
    "Professional Lacrosse Players' Association"     => "PLPA",
    "Programmers Guild"                              => "Programmers",
    "SAG-AFTRA"                                      => "SAG-AFTRA",
    "Seafarers International Union of North America" => "SIUNA",
    "Sheet Metal Workers International Association"  => "SMW",
    "Short Circuits"                                 => undef,
    "Stage Directors and Choreographers Society"     => "SDC",
    "Teamsters for a Democratic Union"               => "TDU",
    "The Guild of Italian American Actors"           => "GIAA",
    "Transport Workers Union of America"             => "TWU",
    "UNITE HERE"                                     => "UNITEHE",
    "US Airline Pilots Association"                  => "USAPA",
    "United American Nurses"                         => "UAN",
    "United Association of Journeymen and Apprentices of the Plumbing, Pipefitting and Sprinkler Fitting Industry of the United States and Canada"
        => "UA",
    "United Automobile, Aerospace & Agricultural Implement Workers of America International Union"
        => "UAW",
    "United Brotherhood of Carpenters and Joiners of America" => "UBC",
    "United Electrical, Radio and Machine Workers of America" => "UE",
    "United Farm Workers of America"                          => "UFW",
    "United Food and Commercial Workers"                      => "UFCW",
    "United Independent Technology Technicians Of America"    => "UITTA",
    "United Independent Technology Technicians of America"    => "UITTA",
    "United Mine Workers of America"                          => "UMW",
    "United Steel, Paper and Forestry, Rubber, Manufacturing, Energy, Allied Industrial and Service Workers International Union"
        => "USWA",
    "United Transportation Union"                               => "UTU",
    "United Union of Roofers, Waterproofers and Allied Workers" => "RWAW",
    "Utility Workers Union of America"                          => "UWU",
    "Workers United"                                            => "WU",
    "World Umpires Association"                                 => "WUA",
    "Writers Guild of America, East"                            => "WGAE",
    "Writers Guild of America, west"                            => "WGAW",
);

# Set abbreviations
for my $org (@all_organizations) {
    next unless $org;
    unless ( $org->{abbreviation} ) {
        if ( $abbreviations{ $org->{name} } ) {
            $org->{abbreviation} = $abbreviations{ $org->{name} };
        }
    }
}

my $labor_organizations_json
    = JSON::XS->new->pretty->encode( \@all_organizations );

io("$directory/labor-organizations.json")->print($labor_organizations_json);

1;
