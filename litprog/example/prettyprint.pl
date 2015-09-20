#!/usr/bin/perl -w

use strict;

my $file = shift @ARGV || die "Usage: $0 file.xml\n";

open (F, $file);
read (F, $_, -s $file);
close (F);

print "<programlisting>";

if (/<!DOCTYPE/) {
    &prettyprint($`);
    $_ = $& . $';

    if (/<!DOCTYPE\s*\S+\s*\[.*?\]>/s) {
	print &charescape($&);
	&prettyprint($');
    } elsif (/<!DOCTYPE.*>/) {
	print &charescape($&);
	&prettyprint($');
    } else {
	die "Unparseable !DOCTYPE declaration.\n";
    }
} else {
    &prettyprint($_);
}

print "</programlisting>\n";

sub prettyprint {
    local $_ = shift;

    while (/<(.*?)>/s) {
	my $post = $';
	$_ = $1;

	print &escape($`);

	if (/^\?(.*)\?$/s) {
	    print &pi($1);
	} elsif (/^\!--(.*)--$/s) {
	    print &comment($1);
	} elsif (/^\/(.*)$/s) {
	    print &endtag($1);
	} else {
	    print &starttag($_);
	}

	$_ = $post;
    }

    print &escape($_);
}

sub escape {
    local $_ = shift;
    my $ret = "";

    while (/&(\S+?);/) {
	my $pre = $`;
	my $ent = $1;
	my $post = $';

	$ret .= &charescape($pre);
	if ($ent =~ /^\#/) {
	    $ret .= &sgmltag('numcharref', $ent);
	} else {
	    $ret .= &sgmltag('genentity', $ent);
	}

	$_ = $post;
    }

    return $ret . &charescape($_);
}

sub charescape {
    local $_ = shift;

    s/&/&amp;/sg;
    s/</&lt;/sg;
    s/>/&gt;/sg;

    return $_;
}

sub sgmltag {
    my $class = shift;
    my $content = shift;

#    my $tagname = "???";
#    $tagname = $1 if $content =~ s/^(\S+)/$1/s;
#    $tagname =~ s/:/-/sg;

    return "<sgmltag class=\"$class\">$content</sgmltag>"
}

sub pi {
    return &sgmltag('xmlpi', $_[0]);
}

sub comment {
    return &sgmltag('sgmlcomment', $_[0]);
}

sub starttag {
    my $content = shift;

    if ($content =~ /\/$/) {
	return &sgmltag('emptytag', $`);
    } else {
	return &sgmltag('starttag', $content);
    }
}

sub endtag {
    return &sgmltag('endtag', $_[0]);
}
