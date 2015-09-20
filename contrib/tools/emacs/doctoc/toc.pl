#!/usr/bin/perl -w
# Generate a table of contents for a docbook document
# tags are case insensitive
# part of doctoc version 2.0

use XML::Parser;
use integer;
use strict;
#use utf8;

package Toc;
# levels:
#       >=0 absolute level
#        -1 additional level relative to current, numbered            
#        -2 additional level relative to current, not numbered,
#           doesn't increase level
#        -3 don't include into toc

# all ellements which can have a title (docbook 3.1)
%Toc::levels = (
           "abstract"           => -1,
           "appendix"           => -2,
           "artheader"          => -3,
           "article"            =>  1,
           "authorblurb"        => -3,
           "bibliodiv"          => -3,
           "biblioentry"        => -3,
           "bibliography"       => -1,
           "bibliomixed"        => -3,
           "bibliomset"         => -3,
           "biblioset"          => -3,
           "blockquote"         => -3,
           "book"               =>  0,
           "bookbiblio"         => -3,
           "bookinfo"           => -3,
           "calloutlist"        => -3,
           "caution"            => -3,
           "chapter"            =>  1,
           "dedication"         => -1,
           "docinfo"            => -1,
           "equation"           => -3,
           "example"            => -3,
           "figure"             => -3,
           "formalpara"         => -2,
           "glossary"           => -1,
           "glossdiv"           => -3,
           "important"          => -1,
           "index"              => -1,
           "indexdiv"           => -3,
           "legalnotice"        => -1,
           "lot"                => -1,
           "msg"                => -3,
           "msgexplan"          => -3,
           "msgmain"            => -3,
           "msgrel"             => -3,
           "msgsub"             => -3,
           "note"               => -3,
           "para"               => -2,
           "part"               =>  0,
           "partintro"          => -1,
           "preface"            => -1,
           "procedure"          => -3,
           "reference"          => -3,
           "refmeta"            => -3,
           "refsect1"           =>  2,
           "refsect1info"       => -3,
           "refsect2"           =>  3,
           "refsect2info"       => -3,
           "refsect3"           =>  4,
           "refsect3info"       => -3,
           "refsect4"           =>  5,
           "refsect5"           =>  6,
           "refsynopsisdiv"     => -3,
           "refsynopsisdivinfo" => -3,
           "sect1"              =>  2,
           "sect1info"          => -3,
           "sect2"              =>  3,
           "sect2info"          => -3,
           "sect3"              =>  4,
           "sect3info"          => -3,
           "sect4"              =>  5,
           "sect4info"          => -3,
           "sect5"              =>  6,
           "sect5info"          => -3,
           "section"            => -1,
           "segmentedlist"      => -3,
           "seriesinfo"         => -1,
           "set"                => -1,
           "setindex"           => -1,
           "setinfo"            => -3,
           "sidebar"            => -3,
           "simplesect"         => -1,
           "step"               => -3,
           "table"              => -3,
           "tip"                => -3,
           "toc"                => -1,
           "variablelist"       => -3,
           "warning"            => -3,
);

@Toc::secnums = (0) x (max(values %Toc::levels)+1); # section numbers
$Toc::parent = "";		# parent of last <title>
$Toc::parentline_no = 0;	# line no of parent
$Toc::parentbase = "";		# base URL of parent
$Toc::minlevel = 0;		# =0 for book, =1 for article
                                # detected automatically
$Toc::currentlevel = 0;		# level of current $title
$Toc::title = "";		# current <title> or <titleabbrev>
$Toc::extraindent_step = 0;	# additionally indent toc entry 
                                # by this much per level
$Toc::width = 75;		# 3 characters needed for outline minor mode
$Toc::fill_character = ".";	# "·" might be nice in some fonts

# return largest
sub max {
  my $max=shift(@_);
  foreach my $i (@_) {
    $max=$i if $i > $max;
  }
  return $max;
}

# emit an toc entry for $parent, $title
sub tocentry {
  use Text::Wrap;
  my $text         = $Toc::title;
  $Toc::title = "";
  my $parent_level = $Toc::levels{$Toc::parent};
  my $line_no      = $Toc::parentline_no;
  my $base         = $Toc::parentbase;
  my $clevel       = $Toc::currentlevel;
  my $mlevel       = $Toc::minlevel;
  my $extra_indent = max(0,($clevel-$mlevel)*$Toc::extraindent_step);

  # strip tags and superflous whitespace
  $text=~s/<[^>]+>//g;
  $text=~s/\s+/ /g;

  # prepend base URL to line number
  $line_no = "$base :$line_no" unless $base eq "-";

  # generate complete number
  my $num="";
  if($parent_level > -2) {
    # numbered entry
    for (my $i=$mlevel+1; $i<=$clevel; $i++) {
      $num .= $Toc::secnums[$i].".";
    }
    chop($num) if $num;
    $num .= " " x (3*($clevel-$mlevel)-1-length($num));
  } else {
    # unnumbered entry
    $num  = " " x (3*($clevel-$mlevel+1)-1);
  }

  # wrap title
  my $pre1 = " " x $extra_indent.$num." ";
  my $pre2 = " " x length($pre1);
  $Text::Wrap::columns = $Toc::width-1-6; # 6 digits for line number
  $text = wrap($pre1, $pre2, $text);
  $text =~ tr/\t/ /;

  # fill last line with points, $l is bare length of last line
  my $l=length($text)-(rindex($text,"\n")+1);
  my $lp = length($line_no);
  # take possibly long position into account
  my $fill=$Toc::width-$lp-$l;
  if($fill < 0) {
    # needs to be on line by itself
    $fill=$Toc::width-$l-6;
    if($lp > $Toc::width-length($pre2)) {
      # doesn't even fit on a regular line
      $line_no = "\n". $pre2 . $line_no;
    } else {
      # fits
      $line_no = "\n". " " x ($Toc::width-$lp) . $line_no;
    }
  }
  unless($fill < 2) {
    $fill = " ".($Toc::fill_character x ($fill-2))." ";
  } else {
    $fill = " ";
  }

  print "$text$fill$line_no\n";
}

# start tag handlers
sub first_stag {
  my $parser=shift;
  my $tagname=lc(shift);
  if($tagname eq "article") {
    $Toc::minlevel = 1;
    $Toc::currentlevel = $Toc::minlevel;
  }
  $Toc::parent=$tagname if exists($Toc::levels{$tagname});
  $parser->setHandlers(Start=>\&stag);
}

sub stag {
  my $parser=shift;
  my $tagname=lc(shift);
  my $element_level;

  if($tagname =~ m/\Atitle(abbrev)?\Z/) {
    # switch data collection on
    $Toc::title = "";
    $parser->setHandlers(Char=>\&cdata) if($Toc::levels{$Toc::parent}>-3);
  } elsif(exists($Toc::levels{$tagname})) {
    &tocentry if $Toc::title; # title was not yet emitted to toc
    $Toc::parent=$tagname;
    $Toc::parentline_no = $parser->current_line();
    $Toc::parentbase = $parser->base();
    $element_level=$Toc::levels{$tagname};
    if($element_level>=0) {
      # look for gaps
      while(++$Toc::currentlevel <= $element_level) {
        $Toc::secnums[$Toc::currentlevel] = 0 
	  unless(defined($Toc::secnums[$Toc::currentlevel]));
      }
      # looking for overlap ist not neccessary
      $Toc::currentlevel = $element_level;
      $Toc::secnums[$Toc::currentlevel]++;
    } elsif ($element_level == -1) {
      $Toc::currentlevel ++;
      if(defined($Toc::secnums[$Toc::currentlevel])) {
        $Toc::secnums[$Toc::currentlevel]++;
      } else {
        $Toc::secnums[$Toc::currentlevel] = 1;
      }
    }
    for(my $i=$Toc::currentlevel+1; $i<=$#Toc::secnums; $i++) {
      $Toc::secnums[$i] = 0;
    }
  }
}

# end tag handler
sub etag {
  my $parser=shift;
  my $tagname=lc(shift);
  if($tagname =~ m/\Atitle(abbrev)?\Z/) {
    $parser->setHandlers(Char=>0);
  } elsif (exists($Toc::levels{$tagname})) {
    &tocentry if $Toc::title; # title was not yet emitted to toc
    $Toc::currentlevel=
      max($Toc::currentlevel-1,0) if ($Toc::levels{$tagname}>=-1);
  }
}

# character data handler
sub cdata {
  $Toc::title .= $_[1];
}

# "main"

my $file = '-';
unshift(@ARGV, $file) unless @ARGV;

  
while(defined($file = shift)) {
  my $parser = new XML::Parser(ErrorContext => 2);
  $parser->setHandlers(Start => \&first_stag,
		       End   => \&etag);
  $parser->parsefile($file);
}

