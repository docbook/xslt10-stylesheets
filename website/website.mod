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
>

<!ELEMENT summary (%word.char.mix;)*>

<!ELEMENT base EMPTY>
<!ATTLIST base
	href	CDATA	#REQUIRED
	target	CDATA	#IMPLIED
>

<!ELEMENT keywords (#PCDATA)>


<!ELEMENT webpage (%webpage.mix;)>
<!ATTLIST webpage
	%html-xmlns;	CDATA	#FIXED %html-namespace;
	%xlink-xmlns;	CDATA	#FIXED %xlink-namespace;
	%rddl-xmlns;	CDATA	#FIXED %rddl-namespace;
	navto		(yes|no)	"yes"
	role		CDATA	#IMPLIED
	id		ID	#REQUIRED
>

<!ELEMENT webtoc EMPTY>

<![%allowrddl;[
<!ENTITY % rddl.mod SYSTEM "rddl.mod">
%rddl.mod;
]]>

<![%allowforms;[
<!ENTITY % forms.mod SYSTEM "forms.mod">
%forms.mod;
]]>

<!-- Allow role attribute on table elements. It's an oversight that these are -->
<!-- not allowed in the DocBook DTD. -->

<!ATTLIST tgroup
	role	CDATA	#IMPLIED
>

<!ATTLIST thead
	role	CDATA	#IMPLIED
>

<!ATTLIST tbody
	role	CDATA	#IMPLIED
>

<!ATTLIST tfoot
	role	CDATA	#IMPLIED
>

<!ATTLIST row
	role	CDATA	#IMPLIED
>

<!ATTLIST entry
	role	CDATA	#IMPLIED
>

<!ATTLIST colspec
	role	CDATA	#IMPLIED
>

<!-- End of Website Module V2.2 ........................................... -->
<!-- ...................................................................... -->
