#!/usr/bin/perl -- # -*- Perl -*-

use strict;
use Getopt::Long;

my $usage = "$0 [--xml | --sgml ] [ --language lang ... ] [ --notlanguage lang ... ]\n";

my %option = ('debug' => 0,
	      'verbose' => 0,
	      'xml' => 0,
	      'sgml' => 0,
	      'language' => undef,
	      'notlanguage' => undef);

my %opt = ();

&GetOptions(\%opt,
	    'debug+',
	    'verbose+',
	    'xml!',
	    'sgml!',
	    'language=s@',
	    'notlanguage=s@');

foreach my $key (keys %option) {
    $option{$key} = $opt{$key} if exists($opt{$key});
}

my %languages = ('af' => 'Afrikaans',
		 'ca' => 'Catalan',
		 'cs' => 'Czech',
		 'da' => 'Danish',
		 'de' => 'German',
		 'el' => 'Greek',
		 'en' => 'English',
		 'es' => 'Spanish',
		 'et' => 'Estonian',
		 'fi' => 'Finnish',
		 'fr' => 'French',
		 'hu' => 'Hungarian',
		 'id' => 'Indonesian',
		 'it' => 'Italian',
		 'ja' => 'Japanese',
		 'ko' => 'Korean',
		 'nl' => 'Dutch',
		 'nn' => 'Nynorsk',
		 'no' => 'Norwegian',
		 'pl' => 'Polish',
		 'pt' => 'Portuguese',
		 'pt_br' => 'Portuguese (Brazil)',
		 'ro' => 'Romanian',
		 'ru' => 'Russian',
		 'sk' => 'Slovak',
		 'sl' => 'Slovenian',
		 'sr' => 'Serbian',
		 'sv' => 'Swedish',
		 'tr' => 'Turkish',
		 'uk' => 'Ukranian',
		 'xh' => 'Xhosa',
		 'zh_cn' => 'Chinese (Continental)',
		 'zh_tw' => 'Chinese (Traditional)');

my %uselanguages = ();

if ($option{'language'}) {
    my @langs = @{$option{'language'}};
    foreach my $lang (@langs) {
	if ($languages{$lang}) {
	    print STDERR "Using ", $languages{$lang}, "\n"
		if $option{'verbose'};
	    $uselanguages{$lang} = 1;
	} else {
	    warn "Unrecognized language: $lang\n";
	}
    }
} else {
    %uselanguages = %languages;
}

if ($option{'notlanguage'}) {
    my @langs = @{$option{'notlanguage'}};
    foreach my $lang (@langs) {
	if ($uselanguages{$lang}) {
	    print STDERR "Suppressing ", $languages{$lang}, "\n"
		if $option{'verbose'};
	    delete($uselanguages{$lang});
	} else {
	    warn "Unused language: $lang\n";
	}
    }
}

my $public_id = "-//OASIS//DTD DocBook XML V4.1.2//EN";
my $system_id = "http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd";

if ($option{'sgml'}) {
    $public_id = "-//OASIS//DTD DocBook V4.1//EN";
    $system_id = "http://www.oasis-open.org/docbook/sgml/4.1/docbook.dtd";
}

print <<EOF3;
<!DOCTYPE book PUBLIC "$public_id"
               "$system_id">
<book lang="de">
<bookinfo>
<title>Book Title</title>
<abstract>
<para>
To test multilingual capability, this book claims to be in German.
Of course, I don't know a word of German so it's really mostly
English.
</para>
</abstract>
</bookinfo>
EOF3

foreach my $lang (sort keys %uselanguages) {
    my $langid = $lang;
    $langid =~ s/_//g;

    print <<EOF;
<chapter lang='$lang' id='${langid}chap'>
<chapterinfo>
<author id='${langid}author'>
  <surname>Surname</surname>
  <firstname>Firstname</firstname>
</author>
</chapterinfo>
<title>$languages{$lang}</title>
<note>
<para>
This paragraph would be in $languages{$lang}, if I knew any.
<quote>Quote test.</quote>
</para>
</note>
<para>Author formatting test: <xref linkend='${langid}author'
EOF

    if ($option{'sgml'}) {
	print ">.</para>\n<para>Cross reference tests:\n";
    } else {
	print "/>.</para>\n<para>Cross reference tests:\n";
    }

    foreach my $otherlang (sort keys %uselanguages) {
	my $otherlangid = $otherlang;
	$otherlangid =~ s/_//g;
	if ($otherlang ne $lang) {
	    print "See <xref linkend='${otherlangid}chap'/>.\n";
	}
    }

    print <<EOF2;
</para>
</chapter>

EOF2
}

print "</book>\n";
