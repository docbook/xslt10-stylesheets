<!-- ====================================================================== -->
<!-- Slides Module V3.3.0
     Copyright (C) 1999, 2000, 2001, 2002, 2003 Norman Walsh
     http://sourceforge.net/projects/docbook/

     $Id$

     Please direct all questions and comments about this DTD to
     Norman Walsh, <ndw@nwalsh.com>.
                                                                            -->
<!-- ====================================================================== -->

<!ENTITY % only-in-full-nav.class "|%nav.class;">

<!ELEMENT slides (slidesinfo, speakernotes?, foil*, foilgroup*)>

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

<!ELEMENT foilgroup (foilgroupinfo?, title, subtitle?, titleabbrev?,
                   (%divcomponent.mix;%only-in-full-nav.class;)*,
                   foil+)>
<!ATTLIST foilgroup
		%label.attrib;
		%status.attrib;
		%common.attrib;
		%role.attrib;
>

<!ELEMENT foilgroupinfo ((mediaobject
		       | legalnotice
                       | subjectset | keywordset
                       | %bibliocomponent.mix;)+)>

<!ATTLIST foilgroupinfo
		%common.attrib;
		%role.attrib;
>

<!ELEMENT foil (foilinfo?, title, subtitle?, titleabbrev?,
                (%divcomponent.mix;%only-in-full-nav.class;)+)>

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

<!-- End of Slides Module V3.3.0 .......................................... -->
<!-- ...................................................................... -->
