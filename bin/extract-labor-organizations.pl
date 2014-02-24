#!/usr/bin/env perl

use strict;
use warnings;

use Web::Scraper;
use IO::All -utf8;
use Data::Printer;
use JSON::XS;
use List::MoreUtils qw/part/;
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

my $html_string = io($file)->all;

$html_string =~ s/’/'/g;
$html_string =~ s/&#39;/'/g;
$html_string =~ s/&nbsp;//g;
$html_string =~ s/\x92/'/g;

my @federations = (
    {   name             => 'American Federation of Labor-Congress of Industrial Organizations',
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
        process "//td[2]", name => "TEXT",
        process "//td[3]", year_established => "TEXT",
        process "//td[4]", members => sub {
            my $elem = shift;
            my $text = $elem->as_text;
            $text =~ s/\D//g;
            return $text;
        },
        process "//td[5]", description => "TEXT",
        process "//td[7]/a", "url" => '@href',
        ;
    };
};

my $largest_unions = $scraper->scrape($html_string);

for my $large_union (@{$largest_unions->{largest}}) {
    if ($large_union->{name} eq
        "National Education Association of the United States")
    {
        $large_union->{federation} = ['EI'];
        $large_union->{abbreviation} = 'NEA';
    }

    if ($large_union->{name} eq "Service Employees International Union") {
        $large_union->{federation} = ['CTW', 'CLC'];
        $large_union->{abbreviation} = 'SEIU';
    }

    if ($large_union->{name} eq
        "American Federation of State, County, and Municipal Employees")
    {
        $large_union->{federation} = ['AFL-CIO'];
        $large_union->{abbreviation} = 'AFSCME';
    }

    if ($large_union->{name} eq "Teamsters") {
        $large_union->{federation} = ['CTW', 'CLC'];
        $large_union->{abbreviation} = 'IBT';
    }

    if ($large_union->{name} eq "United Food and Commercial Workers") {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'UFCW';
    }

    if ($large_union->{name} eq "American Federation of Teachers") {
        $large_union->{federation} = ['AFL-CIO', 'EI'];
        $large_union->{abbreviation} = 'AFT';
    }

    if ($large_union->{name} eq "United Steelworkers") {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'USW';
    }

    if ($large_union->{name} eq
        "International Brotherhood of Electrical Workers")
    {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'IBEW';
    }

    if ($large_union->{name} eq
        "Laborers’ International Union of North America")
    {
        $large_union->{federation} = ['AFL-CIO'];
        $large_union->{abbreviation} = 'Laborers';
    }

    if ($large_union->{name} eq
        "International Association of Machinists and Aerospace Workers")
    {
        $large_union->{federation} = ['AFL-CIO', 'CLC', 'ITF'];
        $large_union->{abbreviation} = 'IAM';
    }

    if ($large_union->{name} eq "United Auto Workers") {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'UAW';
    }

    if ($large_union->{name} eq "Communications Workers of America") {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'CWA';
    }

    if ($large_union->{name} eq
        "United Brotherhood of Carpenters and Joiners of America")
    {
        $large_union->{federation} = ['CLC'];
        $large_union->{abbreviation} = 'UBC';
    }

    if ($large_union->{name} eq
        "Union of Needletrades, Industrial, and Textile Employees")
    {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'UNITE';
    }

    if ($large_union->{name} eq "International Longshore and Warehouse Union")
    {
        $large_union->{federation} = ['CLC'];
        $large_union->{abbreviation} = 'ILWU';
    }

    if ($large_union->{name} eq "International Union of Operating Engineers")
    {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'IUOE';
    }

    if ($large_union->{name} eq "United Association") {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'UA';
    }

    if ($large_union->{name} eq "National Association of Letter Carriers") {
        $large_union->{federation} = ['AFL-CIO', 'UNI'];
        $large_union->{abbreviation} = 'NALC';
    }

    if ($large_union->{name} eq "American Postal Workers Union") {
        $large_union->{federation} = ['AFL-CIO', 'UNI'];
        $large_union->{abbreviation} = 'APWU';
    }

    if ($large_union->{name} eq "International Association of Fire Fighters")
    {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'IAFF';
    }

    if ($large_union->{name} eq "National Postal Mail Handlers Union") {
        $large_union->{federation} = ['AFL-CIO'];
        $large_union->{abbreviation} = 'NPMHU';
    }

    if ($large_union->{name} eq "American Federation of Government Employees")
    {
        $large_union->{federation} = ['AFL-CIO'];
        $large_union->{abbreviation} = 'AFGE';
    }

    if ($large_union->{name} eq "Amalgamated Transit Union") {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'ATU';
    }

    if ($large_union->{name} eq "American Nurses Association") {
        $large_union->{federation} = [];
        $large_union->{abbreviation} = 'ANA';
    }

    if ($large_union->{name} eq
        "Sheet Metal Workers International Association")
    {
        $large_union->{federation} = ['AFL-CIO', 'CLC'];
        $large_union->{abbreviation} = 'SMWIA';
    }

    if ($large_union->{name} eq
        "International Union of Painters and Allied Trades")
    {
        $large_union->{federation} = ['AFL-CIO','CLC'];
        $large_union->{abbreviation} = 'IUPAT';
    }

    if ($large_union->{name} eq
        "International Association of Bridge, Structural, Ornamental, and Reinforcing Iron Workers"
        )
    {
        $large_union->{federation} = ['AFL-CIO','CLC'];
        $large_union->{abbreviation} = 'Ironworkers';
    }

    if ($large_union->{name} eq "Transport Workers Union of America") {
        $large_union->{federation} = ['AFL-CIO'];
        $large_union->{abbreviation} = 'TWU';
    }

    if ($large_union->{name} eq
        "American Association of Classified School Employees")
    {
        $large_union->{federation} = [];
    }

    if ($large_union->{name} eq "National Rural Letter Carriers' Association")
    {
        $large_union->{federation} = [];
        $large_union->{abbreviation} = 'NRLCA';
    }
}

my $scraper2 = scraper {
    process '//div[@id="mw-content-text"]/ul[1]/li', "aflcio[]" => scraper {
        process "li>a", name => "TEXT",
        process "//ul/li", "unions[]" => scraper {
            process "li", name => "TEXT",
        }, 
        ;
    };
};

my $aflcio = $scraper2->scrape($html_string);

my $scraper3 = scraper {
    process '//div[@id="mw-content-text"]/ul[2]/li', "ctw[]" => scraper {
        process "li>a", name => "TEXT",
        process "//ul/li", "unions[]" => scraper {
            process "li", name => "TEXT",
        }, 
        ;
    };
};

my $ctw = $scraper3->scrape($html_string);

my $scraper4 = scraper {
    process '//div[@id="mw-content-text"]/ul[3]/li', "indy[]" => scraper {
        process "li>a", name => "TEXT",
        process "//ul/li", "unions[]" => scraper {
            process "li", name => "TEXT",
        }, 
        ;
    };
};

my $indy = $scraper4->scrape($html_string);

my $scraper5 = scraper {
    process '//div[@id="mw-content-text"]/ul[4]/li', "reform[]" => scraper {
        process "li>a", name => "TEXT",
        process "//ul/li", "unions[]" => scraper {
            process "li", name => "TEXT",
        }, 
        ;
    };
};

my $reform = $scraper5->scrape($html_string);

# Make sure each of the CTW and AFL-CIO unions has its proper federation set.
@{$ctw->{ctw}} = map { $_->{federation} = ['CTW']; $_ } @{$ctw->{ctw}};
@{$aflcio->{aflcio}} = map { $_->{federation} = ['AFL-CIO']; $_ } @{$aflcio->{aflcio}};
@{$reform->{reform}} = map { $_->{type} = 'reform'; $_ } @{$reform->{reform}};

# Put all the unions into one array.
my @unions = (
    @{$largest_unions->{largest}},
    @{$aflcio->{aflcio}},
    @{$ctw->{ctw}},
    @{$indy->{indy}},
    @{$reform->{reform}},
);

# Split unions into those with subunions
my @part = part { exists($_->{unions}) } @unions;

my @normal_unions = @{$part[0]};
my @subfederations = @{$part[1]};

# For each of those unions with subunions, take the subunions,
# give each one a federation from the parent, and push each subunion
# into the big unions array
for my $subfederation (@subfederations) {
    my $unions = delete $subfederation->{unions};
    my $federation =
        $subfederation->{name} eq 'International Brotherhood of Teamsters'
        ? 'IBT'
        : $subfederation->{name} eq 'Service Employees International Union'
        ? 'SEIU'
        : $subfederation->{name} eq
        'Associated Actors and Artistes of America' ? 'AAAA'
        : '';
    @$unions = map {$_->{federation} = [$federation]; $_} @$unions;
    push @normal_unions, @$unions;
}

# Delete IBT and SEIU from subfederations, because we have proper, full
# data for them in the unions array already. We will copy that into
# the federations.
@subfederations = grep { $_->{name} !~ /Teamsters|Service/} @subfederations;

# Set AAAA's abbreviation.
$subfederations[0]->{abbreviation} = 'AAAA';
$subfederations[0]->{type} = 'hybrid';

# Put AAA into the federations array.
push @federations, @subfederations;

# Grab the full IBT and SEIU data from the unions array.
my @federation_parts = part { exists($_->{abbreviation}) && $_->{abbreviation} =~ /(IBT|SEIU)/ } @normal_unions;

my @filtered_unions = @{$federation_parts[0]};
my @filtered_federations = @{$federation_parts[1]};

@filtered_federations = map { $_->{type} = 'hybrid'; $_ } @filtered_federations; 

# Put the full IBT and SEIU data into the federations array.
push @federations, @filtered_federations;

@filtered_unions = map { $_->{type} = 'union'; $_ } @filtered_unions;

my @all_organizations = (@federations,@filtered_unions);

my $labor_organizations_json = JSON::XS->new->pretty->encode( \@all_organizations);

io("$directory/labor-organizations.json")->print($labor_organizations_json);

1;
