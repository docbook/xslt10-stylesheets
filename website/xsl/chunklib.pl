# -*- Perl -*-
# This is a chunk.pl library file

package chunklib;

use XML::DOM;
use Time::Local;

sub init {
    return 1;
}

sub applies {
    my $doc = shift;
    my $node = shift;
    my $parent = shift;

    return 0 if $node->getNodeType() != ELEMENT_NODE;
    return 0 if $node->getTagName() ne 'span';
    return 0 if $node->getAttribute('class') ne 'footdate';
    return 1;
}

sub apply {
    my $doc = shift;
    my $node = shift;
    my $parent = shift;

    if ($node->getTagName() eq 'span'
	&& $node->getAttribute('class') eq 'footdate') {
	my @months = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
		      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

	my $textnode = $node->getFirstChild();
	my $ucsdate = $textnode->getData();

	if ($ucsdate =~ /\$(Date): (....)\/(..)\/(..)\s+(\d+):(..):(..) \$/) {
	    # NB: the extra ()'s around Date prevent CVS from mangling it!
	    # ok, let's convert this sucker!
	    my ($year, $month, $day, $hour, $min, $sec) = ($2,$3,$4,$5,$6,$7);
	    my ($wday, $yday, $isdst);

	    $month--;       # perl months are zero based
	    $year -= 1900;  # perl years are 1900 based

	    # convert GMT into local time
	    my $time = timegm($sec,$min,$hour,$day,$month,$year);
	    ($sec,$min,$hour,$day,$month,$year,$wday,$yday,$isdst) 
		= localtime($time);

	    # Calculate the abbreviation for the local timezone.
	    # I don't know how portable this is. My machine returns
	    # "Eastern Standard Time", so I'm just going to grab
	    # all the capitals out of that.

	    my ($tzs, $tzd) = POSIX::tzname;
	    my $tz = $isdst ? $tzd : $tzs;
	    $tz =~ s/[^A-Z]//g;

	    $year += 1900;

	    my $ampm    = $hour >= 12 ? "pm" : "am";
	    my $lcldate = sprintf("Updated: %02d %s %04d @ %02d:%02d%s %s",
				  $day, $months[$month], $year,
				  $hour > 12 ? $hour - 12 : $hour, $min,
				  $ampm, $tz);

#	    print STDERR "GMT: $ucsdate\n";
#	    print STDERR "EDT: $lcldate\n";

	    $textnode->deleteData(0, $textnode->getLength());
	    $textnode->appendData($lcldate);
	}
    }
}

'chunklib';

