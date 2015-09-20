<!-- ====================================================================== -->
<!-- Website Extensions V2.6
     Copyright (C) 2002 Norman Walsh
     http://sourceforge.net/projects/docbook/

     $Id$

     Please direct all questions and comments about this DTD to
     Norman Walsh, <ndw@nwalsh.com>.
                                                                            -->
<!-- ====================================================================== -->

<!-- allow webtoc to occur anywhere a para can occur -->
<!ENTITY % local.para.class "|webtoc|rss">

<!ENTITY % namespaces.mod
           PUBLIC "-//Norman Walsh//DTD Website Namespaces Module V2.6//EN"
                  "namespaces.mod">
%namespaces.mod;

<!-- RDDL? -->
<!ENTITY % allowrddl "INCLUDE">
<![%allowrddl;[
<!ENTITY % rddl.elements "|%rddl-resource.element;">
<!ENTITY % local.section.attrib
	"rddl	IDREF	#IMPLIED"
>
]]>
<!ENTITY % rddl.elements "">

<!-- Forms? -->
<!ENTITY % allowforms "INCLUDE">
<![%allowforms;[
<!ENTITY % local.para.char.mix "|%html-input.element;|%html-button.element;|%html-label.element;|%html-select.element;|%html-textarea.element; %rddl.elements;">
<!ENTITY % local.divcomponent.mix "|%html-form.element;">
]]>
<!ENTITY % local.para.char.mix "%rddl.elements;">

<!-- the XML notation; this really should go in DocBook -->
<!NOTATION XML SYSTEM "http://www.w3.org/TR/REC-xml">
<!ENTITY % local.notation.class "">
<!ENTITY % notation.class
		"BMP| CGM-CHAR | CGM-BINARY | CGM-CLEAR | DITROFF | DVI
		| EPS | EQN | FAX | GIF | GIF87a | GIF89a 
		| JPG | JPEG | IGES | PCX
		| PIC | PNG | PS | SGML | XML | TBL | TEX | TIFF | WMF | WPG
		| linespecific
		%local.notation.class;">

<!-- End of Website Extensions V2.6 ..................................... -->
<!-- ...................................................................... -->
