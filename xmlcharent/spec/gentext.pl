#!/usr/bin/perl -- # -*- Perl -*-
# build the character entity tables from the glyphtable map
# This script must be run in the 'build' directory

use XML::DOM;

$verbose = 1;
$entities = "8879.xml";
$desctag = "isodesc";

my $parser = new XML::DOM::Parser (NoExpand => 0);
print STDERR "Loading $entities...";
$doc = $parser->parsefile($entities);
$root = $doc->getDocumentElement();
$entlist = $root->getElementsByTagName('entity');
print STDERR "\n";

%hex = ();
%desc = ();
for (my $count = 0; $count < $entlist->getLength(); $count++) {
    my $ent = $entlist->item($count);
    my $ucode = $ent->getAttribute('ucode');

    if ($ucode eq '' && $ent->getAttribute('ucode-subst')) {
	$ucode = $ent->getAttribute('ucode-subst');
    }

    my $name = $ent->getAttribute('name');
    my $iso = $ent->getAttribute('iso');
    my $desce = $ent->getElementsByTagName($desctag)->item(0);
    my $text = $desce->toString();
    $text = $1 if $text =~ /<$desctag>(.*)<\/$desctag>/;

    next if $ucode eq '';
    warn "Ignoring dup: $name\n", next if $hex{$name};

    $hex{$name} = $ucode;
    $desc{$name} = $text;
}

$dir = "../entities";
$tbldir = ".";
$glyphdir = "/sourceforge/docbook/defguide/glyphs/100dpi";

$missglyph = 0;
$unkglyph = 0;

opendir(DIR, $dir);
while ($name = readdir(DIR)) {
    $file = "$dir/$name";

    next if ! -f $file;
    next if $name !~ /^(.*)\.ent$/;

    $base = $1;

    open (TBL, ">$tbldir/$base.gen");

    print TBL "<informaltable pgwide='1'>\n";
    print TBL "<tgroup cols='5'>\n";
    print TBL "<?dbhtml table-summary=\"Unicode character entity table\"?>\n";
    print TBL "<colspec colwidth=\"15*\"/>\n";
    print TBL "<colspec colwidth=\"15*\" align='center'/>\n";
    print TBL "<colspec colwidth=\"10*\" align='center'/>\n";
    print TBL "<colspec colwidth=\"40*\" colname='desc'/>\n";
    print TBL "<colspec colwidth=\"20*\" colname='math'/>\n";
    print TBL "<thead>\n";
    print TBL "<row>\n";
    print TBL "  <entry align='center'>Entity <?lb?>Name</entry>\n";
    print TBL "  <entry align='center'>Unicode <?lb?>Code point</entry>\n";
    print TBL "  <entry align='center'>Sample <?lb?>Glyph</entry>\n";
    print TBL "  <entry align='left' namest='desc' nameend='math'>Description</entry>\n";
    print TBL "</row>\n";
    print TBL "</thead>\n";
    print TBL "<tbody>\n";

    open(F, $file);
    while (<F>) {
	chop;
	if (/<!ENTITY\s+(\S+)\s+.*?--[=\/]?(.*)--/) {
	    my($name, $desc) = ($1,$2);

	    $desc = $1 if $desc =~ /[A-Z]:\s*(.*)/;
	    $desc =~ s/\&/\&amp;/g;
	    $desc =~ s/\</\&lt;/g;

	    $desc = $desc{$name} if exists($desc{$name});

	    # let's patch the description
	    # see SGML Handbook, p502,503
	    my %relation = ("A" => "[Relation (arrow)]",
			    "B" => "[Binary operator]",
			    "C" => "[Closing delimiter]",
			    "L" => "[Large operator]",
			    "N" => "[Relation (negated)]",
			    "O" => "[Opening delimiter]",
			    "P" => "[Punctuation]",
			    "R" => "[Relation]");

	    my $math = undef;
	    $desc =~ s/\/\S+\s*//sg; # remove references to MathSci chars
	    if ($desc =~ /([ABCLNOPR]):\s*/) {
		$desc = $` . $'; # '
		$math = $relation{$1};
	    }
	    if ($desc =~ /^\s*=/) {
		$desc = $'; # '
	    }

	    $glyph = "Blank";

	    $code = "FFFD";
	    $code = $hex{$name} if $hex{$name};

	    if ($hex{$name} && -f "$glyphdir/U$code.png") {
		$glyph = "U$code";
	    } else {
		$glyph = "$name";
		$glyph = "vsubn-cap-E" if $name eq 'vsubnE';
		$glyph = "vsupn-cap-E" if $name eq 'vsupnE';
		$glyph = "xh-cap-Arr" if $name eq 'xhArr';

		if (-f "$glyphdir/$glyph.png") {
		    $glyph = "glyph.$glyph";
		} else {
		    $glyph = "Unknown";
		    $code = "&nbsp;";
		    print STDERR "$name\t\t$desc\n" if $verbose;
		    $unkglyph++;
		}
	    }

	    my $id = $name;
	    $id = "$name.1" if $name eq 'inodot';
	    $id = "$name.2" if $name eq 'inodot' && $file =~ /iso-amso/;

	    print TBL "<row>\n  <entry id=\"$id\">$name</entry><entry align='center'>$code</entry>\n";
	    print TBL "  <entry valign='bottom'>";
	    print TBL "<mediaobject>\n<imageobject>\n";
	    print TBL "<imagedata entityref=\"$glyph\"/>\n";
	    print TBL "</imageobject>\n";
	    print TBL "<textobject>\n";
	    print TBL "<phrase>Unicode $code</phrase>\n";
	    print TBL "</textobject>\n";
	    print TBL "</mediaobject>";

	    print TBL "</entry>\n  ";

	    if ($math) {
		print TBL "<entry>$desc</entry>\n  ";
		print TBL "<entry align='right'>$math</entry>\n";
	    } else {
		print TBL "<entry namest='desc' nameend='math'>$desc</entry>\n";
	    }

	    print TBL "</row>\n";
	}
    }
    close (F);

    print TBL "</tbody>\n";
    print TBL "</tgroup>\n";
    print TBL "</informaltable>\n";

}
closedir(DIR);

print "$missglyph missing glyphs.\n";
print "$unkglyph unknown glyphs (no graphic).\n";
