#!/usr/bin/perl

# Script to compare the English locale file to any
# or all other locale files to see what is missing
# or extra.

$USAGE = "\n$0 ??.xml [...]

   where ??.xml is a non-English locale file.
   Report written to standard output showing what
   templates are missing or extra.
   You can feed it more than one, or *.xml for all.

";

if ( scalar(@ARGV) < 1 ) {
    print "$USAGE";
    exit 0;
}

open MASTER, "<en.xml";

my $context;
my %mastertemplate;
my @mastergentext;
my @masterdingbat;
my @contexts;
my %template;

while(<MASTER>) {
    if ( /<gentext\s+key="(.*?)"/ ) {
	push @mastergentext, $1;
    }
    if ( /<dingbat\s+key="(.*?)"/ ) {
	push @masterdingbat, $1;
    }
    if ( /<context\s+name="(.*?)"/ ) {
	$context = $1;
	push @contexts, $context;
    }
    if ( m|<template\s+name="(.*?)".*?>(.*?)</template>| ) {
	$mastertemplate{$context}{$1} = $2;
    }
}

for $input ( @ARGV ) {
    open INPUT, "<$input";
    while(<INPUT>) {
    	if ( /<gentext\s+key="(.*?)"/ ) {
		push @gentext, $1;
    	}
    	if ( /<dingbat\s+key="(.*?)"/ ) {
		push @dingbat, $1;
    	}
    	if ( /<context\s+name="(.*?)"/ ) {
		$context = $1;
    	}
    	if ( m|<template\s+name="(.*?)".*?>(.*?)</template>| ) {
		$template{$context}{$1} = $2;
    	}
    }
    close INPUT;

    print "###########################################\n";
    print "###   $input                               \n";
    print "###########################################\n";
    # scan through master to see if missing in the other
    print "=========================== gentext \n";
    foreach my $name ( @mastergentext ) {
	unless ( grep /^$name$/, @gentext ) {
	    print "Missing gentext $name\n";
	}
    }
    print "=========================== dingbat \n";
    foreach my $name ( @masterdingbat ) {
	unless ( grep /^$name$/, @dingbat ) {
	    print "Missing dingbat $name\n";
	}
    }
    foreach my $context (@contexts) {
	print "=========================== context $context \n";
	foreach my $name ( keys %{ $mastertemplate{$context} } ) {
	    unless ( $template{$context}{$name} ) {
	    	print "Missing template $name = $mastertemplate{$context}{$name}\n";
	    }
	}
	foreach my $name ( keys %{ $template{$context} } ) {
	    unless ( $mastertemplate{$context}{$name} ) {
	    	print "Extra template not in master $name = $template{$context}{$name}\n";
	    }
	}
    }
    # scan through other to see if missing in master
    foreach my $name ( @gentext ) {
	unless ( grep /^$name$/, @mastergentext ) {
	    print "Extra gentext not in master: $name\n";
	}
    }
    foreach my $name ( @dingbat ) {
	unless ( grep /^$name$/, @masterdingbat ) {
	    print "Extra dingbat not in master: $name\n";
	}
    }
}
