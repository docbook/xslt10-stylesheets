#!/usr/bin/perl -- # -*- Perl -*-

use utf8;
use open ':utf8';
use Encode;
use English;

# Simple script to cleanup the output of the stylesheets. It fiddles with
# spurious namespace declarations, mostly. And adds newlines between the
# definitions.

# 20 Oct 2005: I decided to simply move *all* namespace decls to the root
# ant to make it an error if there are any collisions. Not as general,
# but the result is nicer. It's too pass, though. So what.

binmode(STDOUT, ":utf8");

my $schematron_uri = "http://www.ascc.net/xml/schematron";
my $schematron_pfx = "";

my %xmlns = ();
my @lines = ();
while (<>) {
    push(@lines, $_);

    while (/<[^\/]\S+(.*)?>/) {
	my $start = $1;
	$_ = $POSTMATCH;

	if ($start =~ / xmlns=([\"\'])(.*?)\1/) {
	    if (exists $xmlns{"*"}) {
		die "Duplicate default namespace declaration.\n"
		    if $xmlns{"*"} ne $2;
	    } else {
		$xmlns{"*"} = $2;
		$schematron_pfx = "" if $2 eq $schematron_uri;
	    }
	    $start = $PREMATCH . $POSTMATCH;
	}

	while ($start =~ / xmlns:(\S+)=([\"\'])(.*?)\2/) {
	    if (exists $xmlns{$1}) {
		die "Duplicate namespace declaration for $1.\n"
		    if $xmlns{$1} ne $3;
	    } else {
		$xmlns{$1} = $3;
		$schematron_pfx = "$1:" if $3 eq $schematron_uri;
	    }
	    $start = $PREMATCH . $POSTMATCH;
	}
    }
}

while (@lines) {
    $_ = shift @lines;
    last if /<[a-z]/i;
    print $_;
}

if (/<(\S+)\s(.*?)>/i) {
    my $tag = $1;
    my $attlist = $2;
    my %atts = ();

    $_ = $POSTMATCH;

    while ($attlist =~ /^\s*(\S+)=([\"\'])(.*?)\2/) {
	my $att = $1;
	my $quote = $2;
	my $value = $3;
	$attlist = $POSTMATCH;
	$atts{$1} = "$quote$value$quote" unless $att =~ /^xmlns/;
    }

    print "<$tag ";
    foreach my $ns (sort keys %xmlns) {
	if ($ns eq '*') {
	    print "xmlns";
	} else {
	    print "xmlns:$ns";
	}
	print "=\"", $xmlns{$ns}, "\"\n";
	print " " x (length($tag)+2);
    }

    my @attnames = sort keys %atts;
    while (@attnames) {
	my $att = shift @attnames;
	print "$att=", $atts{$att};
	print "\n", " " x (length($tag)+2) if @attnames;
    }

    print ">";
    print $_;

    foreach my $ns (sort keys %xmlns) {
	next if $ns eq '*';
	print "<${schematron_pfx}ns ";
	print "prefix=\"$ns\" ";
	print "uri=\"", $xmlns{$ns}, "\"/>\n";
    }
} else {
    die "Can't parse start tag?\n";
}

while (@lines) {
    $_ = shift @lines;

    s/<rng:/</g;
    s/<\/rng:/<\//g;

    s/\s+xmlns=([\"\']).*?\1\s*/ /g;
    s/\s+xmlns:\S+=([\"\']).*?\1\s*/ /g;

    print $_;
    print "\n" if /<\/define>/ || /<ctrl:/ || /<\/start>/;
}
