#!/usr/bin/perl -- # -*- Perl -*-

# Simple script to cleanup the output of the stylesheets. It fiddles with
# spuriouis namespace declarations, mostly. And adds newlines between the
# definitions.

while (<>) {
    s/<rng:/</g;
    s/<\/rng:/<\//g;
    s/\s+xmlns:rng=[\"\'].*?[\"\']\s+/ /g;
    s/\s*xmlns:rng=[\"\'].*?[\"\']\s*//g;
    s/\s+xmlns:ctrl=[\"\'].*?[\"\']\s+/ /g;
    s/\s*xmlns:ctrl=[\"\'].*?[\"\']\s*//g;
    print $_;
    print "\n" if /<\/define>/;
}
