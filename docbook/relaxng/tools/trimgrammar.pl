#!/bin/perl -- # -*- Perl -*-

use strict;
use XML::DOM;
use Getopt::Std;
use vars qw($opt_o $opt_v $opt_r);
use open ':utf8';

my $usage = "Usage: $0 [-v] [-r] [-o file] file\n";

die $usage if ! getopts('o:rv');

my $output = $opt_o || "-";
my $verbose = $opt_v;
my $showRecurse = $opt_r;

my $xmlfile = shift @ARGV || die "Usage: $0 xmlfile\n";

my $parser = new XML::DOM::Parser (NoExpand => 0);
my $xmldoc = $parser->parsefile($xmlfile);
my $root   = $xmldoc->getDocumentElement();

my %patterns = ();

findPatterns($root);

my $start = $patterns{"*start"};
delete $patterns{"*start"};

my @pats = keys %patterns;
my $totPat = $#pats + 1;

print STDERR "There are $#pats patterns in $xmlfile.\n";

my %used = ();

recurse($start ,1);

@pats = keys %used;
my $usedPat = $#pats + 1;

print STDERR "Discarding ", $totPat-$usedPat, " unused patterns in $xmlfile.\n";

if ($verbose) {
    foreach my $pat (sort keys %patterns) {
	if (!$used{$pat}) {
	    print STDERR "\t$pat\n";
	}
    }
}

open (SAVEOUT, ">&STDOUT");
close (STDOUT);
open (STDOUT, ">$output");
printXML($root);
close (STDOUT);
open (STDOUT, ">&SAVEOUT");

exit 0;

sub findPatterns {
    my $element = shift;

    my $child = $element->getFirstChild();

    while ($child) {
	if ($child->getNodeType() == XML::DOM::ELEMENT_NODE) {
	    if ($child->getTagName() eq 'define') {
		$patterns{$child->getAttribute('name')} = $child;
	    } elsif ($child->getTagName() eq 'start') {
		$patterns{"*start"} = $child;
	    } elsif ($child->getTagName() eq 'div') {
		findPatterns($child);
	    }
	}

	$child = $child->getNextSibling();
    }
}

sub recurse {
    my $node = shift;
    my $depth = shift || 0;
    my $child = $node->getFirstChild();

#    print "X", " " x $depth, $node->getTagName();
#    print " (", $node->getAttribute('name'), ")\n";

    while ($child) {
	if ($child->getNodeType() == XML::DOM::ELEMENT_NODE) {
	    if ($child->getTagName() eq 'define') {
		my $name = $child->getAttribute('name');
		if (! exists $used{$name}) {
		    $used{$name} = 1;
		    print "D", " " x $depth, $name, "\n" if $showRecurse;
		    die "No pattern for $name\n" if ! exists $patterns{$name};
		    recurse($patterns{$name},$depth+1);
		}
	    } elsif ($child->getTagName() eq 'ref') {
		my $name = $child->getAttribute('name');
		if (! exists $used{$name}) {
		    $used{$name} = 1;
		    print "R", " " x $depth, $name, "\n" if $showRecurse;
		    die "No pattern for $name\n" if ! exists $patterns{$name};
		    recurse($patterns{$name},$depth+1);
		}
	    } else {
		recurse($child, $depth);
	    }
	}

	$child = $child->getNextSibling();
    }
}

sub printXML {
    my $node = shift;

    if ($node->getNodeType() == XML::DOM::ELEMENT_NODE) {
	my $child = $node->getFirstChild();
	my $attrs = $node->getAttributes();

	print "<";
	print $node->getTagName();

	for (my $count = 0; $count < $attrs->getLength(); $count++) {
	    my $attr = $attrs->item($count);
	    my $name = $attr->getName();
	    my $value = $attr->getValue();
	    print " $name=\"$value\"";
	}

	if ($node->getTagName eq 'define'
	    && !$used{$node->getAttribute('name')}) {
	    print " unused=\"1\"";
	}

	if ($child) {
	    print ">";
	    while ($child) {
		printXML($child);
		$child = $child->getNextSibling();
	    }
	    print "</";
	    print $node->getTagName();
	    print ">";
	} else {
	    print "/>";
	}
    } elsif ($node->getNodeType() == XML::DOM::TEXT_NODE) {
	print $node->getData();
    } elsif ($node->getNodeType() == XML::DOM::COMMENT_NODE) {
	print "<!--", $node->getData(), "-->";
    } elsif ($node->getNodeType() == XML::DOM::PROCESSING_INSTRUCTION_NODE) {
	print "<?", $node->getTarget(), " ", $node->getData(), "?>";
    } else {
	die "Unexpected node type: ", $node->getNodeType(), "\n";
    }
}

sub printXML_OLD {
    my $node = shift;

    if ($node->getNodeType() == XML::DOM::ELEMENT_NODE) {
	if ($node->getTagName ne 'define'
	    || $used{$node->getAttribute('name')}) {
	    my $child = $node->getFirstChild();
	    my $attrs = $node->getAttributes();

	    print "<";
	    print $node->getTagName();

	    for (my $count = 0; $count < $attrs->getLength(); $count++) {
		my $attr = $attrs->item($count);
		my $name = $attr->getName();
		my $value = $attr->getValue();
		print " $name=\"$value\"";
	    }

	    if ($child) {
		print ">";
		while ($child) {
		    printXML($child);
		    $child = $child->getNextSibling();
		}
		print "</";
		print $node->getTagName();
		print ">";
	    } else {
		print "/>";
	    }
	}
    } elsif ($node->getNodeType() == XML::DOM::TEXT_NODE) {
	print $node->getData();
    } elsif ($node->getNodeType() == XML::DOM::COMMENT_NODE) {
	print "<!--", $node->getData(), "-->";
    } elsif ($node->getNodeType() == XML::DOM::PROCESSING_INSTRUCTION_NODE) {
	print "<?", $node->getTarget(), " ", $node->getData(), "?>";
    } else {
	die "Unexpected node type: ", $node->getNodeType(), "\n";
    }
}

