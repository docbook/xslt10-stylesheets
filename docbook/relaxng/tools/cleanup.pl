#!/usr/bin/perl -- # -*- Perl -*-

use open ':utf8';

# Simple script to cleanup the output of the stylesheets. It fiddles with
# spuriouis namespace declarations, mostly. And adds newlines between the
# definitions.

while (<>) {
    s/<rng:/</g;
    s/<\/rng:/<\//g;
    s/\s+xmlns:rng=([\"\']).*?\1\s+/ /g;
    s/\s*xmlns:rng=([\"\']).*?\1\s*//g;

    s/\s+xmlns:ctrl=([\"\']).*?\1\s+/ /g;
    s/\s*xmlns:ctrl=([\"\']).*?\1\s*//g;

    s/\s+xmlns:s=([\"\']).*?\1\s+/ /g;
    s/\s*xmlns:s=([\"\']).*?\1\s*//g;

    s/<(s:rule\s+.*?)>/<\1 xmlns:s=\"http:\/\/www.ascc.net\/xml\/schematron\">/g;
    s/<(ctrl:\S+\s+.*?)(\/?>)/<\1 xmlns:ctrl=\"http:\/\/nwalsh.com\/xmlns\/schema-control\/\"\2/g;

    print $_;
    print "\n" if /<\/define>/ || /<ctrl:/ || /<\/start>/;
}
