<!-- ====================================================================== -->
<!-- Slides Module V2.0
     Copyright (C) 1999, 2000, 2001, 2002 Norman Walsh
     http://sourceforge.net/projects/docbook/

     $Id$

     Please direct all questions and comments about this DTD to
     Norman Walsh, <ndw@nwalsh.com>.
                                                                            -->
<!-- ====================================================================== -->

<!ELEMENT slides (slidesinfo, speakernotes?, (foil+|section+))>
<!ATTLIST slides
		%label.attrib;
		%status.attrib;
		%common.attrib;
		%role.attrib;
>

<!ELEMENT slidesinfo ((mediaobject
		       | legalnotice
                       | subjectset | keywordset
                       | %bibliocomponent.mix;)+)>

<!ATTLIST slidesinfo
		%common.attrib;
		%role.attrib;
>

<!ELEMENT section (sectioninfo?, title, subtitle?, titleabbrev?,
                   speakernotes?,
                   foil+)>
<!ATTLIST section
		%label.attrib;
		%status.attrib;
		%common.attrib;
		%role.attrib;
>

<!ELEMENT sectioninfo ((mediaobject
		       | legalnotice
                       | subjectset | keywordset
                       | %bibliocomponent.mix;)+)>

<!ATTLIST sectioninfo
		%common.attrib;
		%role.attrib;
>

<!ELEMENT foil (foilinfo?, title, subtitle?, titleabbrev?,
                (%divcomponent.mix;)+)>

<!ATTLIST foil
		%label.attrib;
		%status.attrib;
		%common.attrib;
		%role.attrib;
>

<!ELEMENT foilinfo ((mediaobject
		         | legalnotice
                         | subjectset | keywordset
                         | %bibliocomponent.mix;)+)>

<!ATTLIST foilinfo
		%common.attrib;
		%role.attrib;
>

<!ELEMENT speakernotes (%divcomponent.mix;)*>
<!ATTLIST speakernotes
		%common.attrib;
		%role.attrib;
>

<!-- End of Slides Module V2.0 ............................................ -->
<!-- ...................................................................... -->
