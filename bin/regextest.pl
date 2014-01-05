#!/usr/bin/perl 
#===============================================================================
#
#         FILE: regextest.pl
#
#        USAGE: ./regextest.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 12/29/2013 02:44:44 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

my $string = #"%1996.5 Xd  %";
"# oper by CR 1976.3-1977.8, then MINT";

#$string =~ /%(\d{4}(?:\.\d+)?) (\w+)/;
#$string =~ /%(\d{4}(?:\.\d+)?) (\w+\s*?(?:\w+)?)\s*?%/;
#$string =~ /^# (.+?)$/;
#$string = "%1920 YMV MSRC  %";
$string = "[1994 RM&C  ]";

$string =~ /\[(\d{1,4}(?:\.\d+)?) ([\w&]+)\s*?(\w+)?\s*?\]/;

warn $1;
warn $2;
#warn $3;
##warn $2;
#sub parsedate {
    #my ($date) = @_;
    #if ( $date =~ /(\d+)\.(\d+)/ ) {
        #my $year  = $1;
        #my $month = $2 + 1;
        #$date = $month . '/' . $year;
    #}
    #return $date;
#}
#my $owner = "oper by CR 1976.3-1977.8, then MINT"; 

        #if ($owner =~ /(\d{4}(?:\.\d+)?)/) {
            #$owner =~ s/(\d{4}(?:\.\d+)?)/parsedate($1)/eg;
        #}

#warn $owner;
