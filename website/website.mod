<!-- ====================================================================== -->
<!-- Website Module V2.2
     Copyright (C) 2002 Norman Walsh
     http://sourceforge.net/projects/docbook/

     $Id$

     Please direct all questions and comments about this DTD to
     Norman Walsh, <ndw@nwalsh.com>.
                                                                            -->
<!-- ====================================================================== -->

<!ENTITY % webpage.mix "(config*, head, (%bookcomponent.content;),
                        appendix*, bibliography*)">

<!ELEMENT head (title, titleabbrev?, subtitle?, summary?, base?, keywords?,
               (copyright | author | edition
                | meta | script | style | abstract | revhistory
                %rddl.elements;)*)>

<!ELEMENT meta EMPTY>
<!ATTLIST meta
	http-equiv	CDATA	#IMPLIED
	name	CDATA	#IMPLIED
	content	CDATA	#REQUIRED
>

<!ELEMENT script (#PCDATA)>
<!ATTLIST script
	src	CDATA	#IMPLIED
	language	CDATA	#IMPLIED
>

<!ELEMENT style (#PCDATA)>
<!ATTLIST style
	src	CDATA	#IMPLIED
	type	CDATA	#IMPLIED
>

<!ELEMENT config EMPTY>
<!ATTLIST config
	param	CDATA	#REQUIRED
	value	CDATA	#REQUIRED
	altval	CDATA	#IMPLIED
        %common.attrib;
>

<!ELEMENT summary (%word.char.mix;)*>
<!ATTLIST summary
        %common.attrib;
>

<!ELEMENT base EMPTY>
<!ATTLIST base
	href	CDATA	#REQUIRED
	target	CDATA	#IMPLIED
>

<!ELEMENT keywords (#PCDATA)>
<!ATTLIST keywords
        %common.attrib;
>

<!ELEMENT webpage (%webpage.mix;)>
<!ATTLIST webpage
	%html-xmlns;	CDATA	#FIXED %html-namespace;
	%xlink-xmlns;	CDATA	#FIXED %xlink-namespace;
	%rddl-xmlns;	CDATA	#FIXED %rddl-namespace;
	navto		(yes|no)	"yes"
        %common.attrib;
>

<!ELEMENT webtoc EMPTY>
<!ATTLIST webtoc
        %common.attrib;
>

<!ELEMENT rss EMPTY>
<!ATTLIST rss
	feed	CDATA	#REQUIRED
        %common.attrib;
>

<![%allowrddl;[
<!ENTITY % rddl.mod PUBLIC "-//Norman Walsh//DTD Website RDDL Module V2.2//EN"
                    "rddl.mod">
%rddl.mod;
]]>

<![%allowforms;[
<!ENTITY % forms.mod PUBLIC "-//Norman Walsh//DTD Website Forms Module V2.2//EN"
                     "forms.mod">
%forms.mod;
]]>

<!-- End of Website Module V2.2 ........................................... -->
<!-- ...................................................................... -->
