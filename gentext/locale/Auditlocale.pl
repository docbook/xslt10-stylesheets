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

# Treat file as single line
local $/;
undef $/;

open MASTER, "<en.xml";

# slurp whole file into a variable
my $master = <MASTER>;

close MASTER;

my %mastertemplate;
my @mastergentext;
my @masterdingbat;
my @contexts;

while ( $master =~ /<gentext\s+key="(.*?)"/gs ) {
    push @mastergentext, $1;
}

while ( $master =~ /<dingbat\s+key="(.*?)"/gs ) {
    push @masterdingbat, $1;
}

while ( $master =~ m|<context\s+name="(.*?)"\s*>(.*?)</context>|gs ) {
    my $context = $1;
    my $templates = $2;
    push @contexts, $context;

    while ( $templates =~ m|<template\s+name="(.*?)".*?>(.*?)</template>|gs ) {
        $mastertemplate{$context}{$1} = $2;
    }
}

for $inputfile ( @ARGV ) {
    local $/;
    undef $/;
    my @gentext;
    my @dingbat;
    my %template;
    open INPUT, "<$inputfile";
    my $input = <INPUT>;
    close INPUT;

    while( $input =~ /<gentext\s+key="(.*?)"/gs ) {
        push @gentext, $1;
    }
    while( $input =~ /<dingbat\s+key="(.*?)"/gs ) {
        push @dingbat, $1;
    }

    while ( $input =~ m|<context\s+name="(.*?)"\s*>(.*?)</context>|gs ) {
        my $context = $1;
        my $templates = $2;
    
        while ( $templates =~ m|<template\s+name="(.*?)".*?>(.*?)</template>|gs ) {
            $template{$context}{$1} = $2;
        }
    }



    print "###########################################\n";
    print "###   $inputfile                           \n";
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
