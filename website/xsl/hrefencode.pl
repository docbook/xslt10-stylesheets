# -*- Perl -*-
# This is a chunk.pl library file

package hrefencode;

use XML::DOM;

sub init {
    return 1;
}

sub applies {
    my $doc = shift;
    my $node = shift;
    my $parent = shift;

    return 0 if $node->getNodeType() != ELEMENT_NODE;
    return 0 if $node->getTagName() ne 'a';
    return 1;
}

sub apply {
    my $doc = shift;
    my $node = shift;
    my $parent = shift;

    if ($node->getTagName() eq 'a' && $node->getAttribute('href') ne '') {
	my $href = $node->getAttribute('href');
	if ($href =~ /^(.*)?([\?\&])(.*)$/) {
	    my $prefix = $1;
	    my $sep = $2;
	    my $rest = $3;

	    $rest =~ s/[\s\&\?\{\}\|\\\/\^\~\[\]\`\%\+]/sprintf("%%%02X", ord($&))/eg;

	    $node->setAttribute('href', $prefix . $sep . $rest);
	}
    }
}

'hrefencode';


