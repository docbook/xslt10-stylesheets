<!-- ...................................................................... -->
<!-- DocBook information pool module V2.3 ................................. -->
<!-- File dbpool.mod ...................................................... -->

<!-- Copyright 1992, 1993, 1994, 1995 HaL Computer Systems, Inc.,
     O'Reilly & Associates, Inc., and ArborText, Inc.

     Permission to use, copy, modify and distribute the DocBook DTD and
     its accompanying documentation for any purpose and without fee is
     hereby granted, provided that this copyright notice appears in all
     copies.  The copyright holders make no representation about the
     suitability of the DTD for any purpose.  It is provided "as is"
     without expressed or implied warranty.

     If you modify the DocBook DTD in any way, except for declaring and
     referencing additional sets of general entities and declaring
     additional notations, label your DTD as a variant of DocBook.  See
     the maintenance documentation for more information.

     Please direct all questions, bug reports, or suggestions for
     changes to the davenport@online.ora.com mailing list or to one of
     the maintainers:

     o Terry Allen, O'Reilly & Associates, Inc.
       101 Morris St., Sebastopol, CA 95472
       <terry@ora.com>

     o Eve Maler, ArborText, Inc.
       105 Lexington St., Burlington, MA 01803
       <elm@arbortext.com>
-->

<!-- ...................................................................... -->

<!-- This module contains the definitions for the objects, inline
     elements, and so on that are available to be used as the main
     content of DocBook documents.  Some elements are useful for general
     publishing, and others are useful specifically for computer
     documentation.

     This module has the following dependencies on other modules:

     o It assumes that a %notation.class; entity is defined by the
       driver file or other high-level module.  This entity is
       referenced in the NOTATION attributes for the graphic-related and
       ModeSpec elements.

     o It assumes that an appropriately paramterized table module is
       available for use with the table-related elements.

     In DTD driver files referring to this module, please use an entity
     declaration that uses the public identifier shown below:

     <!ENTITY % dbpool PUBLIC
     "-//Davenport//ELEMENTS DocBook Information Pool V2.3//EN">
     %dbpool;

     See the maintenance documentation for detailed information on the
     parameter entity and module scheme used in DocBook, customizing
     DocBook and planning for interchange, and changes made since the
     last release of DocBook.
-->

<!-- ...................................................................... -->
<!-- Entities for module inclusions ....................................... -->

<!ENTITY % dbpool.redecl.module		"IGNORE">

<!ENTITY % abbrev.module		"INCLUDE">
<!ENTITY % abstract.module		"INCLUDE">
<!ENTITY % ackno.module			"INCLUDE">
<!ENTITY % acronym.module		"INCLUDE">
<!ENTITY % action.module		"INCLUDE">
<!ENTITY % address.module		"INCLUDE">
<!ENTITY % address.content.module	"INCLUDE">
<!ENTITY % admon.module			"INCLUDE">
<!ENTITY % affiliation.module		"INCLUDE">
<!ENTITY % affiliation.content.module	"INCLUDE">
<!ENTITY % anchor.module		"INCLUDE">
<!ENTITY % application.module		"INCLUDE">
<!ENTITY % arg.module			"INCLUDE">
<!ENTITY % artheader.module		"INCLUDE">
<!ENTITY % artpagenums.module		"INCLUDE">
<!ENTITY % author.module		"INCLUDE">
<!ENTITY % authorblurb.module		"INCLUDE">
<!ENTITY % authorgroup.module		"INCLUDE">
<!ENTITY % authorgroup.content.module	"INCLUDE">
<!ENTITY % authorinitials.module	"INCLUDE">
<!ENTITY % beginpage.module		"INCLUDE">
<!ENTITY % biblioentry.content.module	"INCLUDE">
<!ENTITY % biblioentry.module		"INCLUDE">
<!ENTITY % bibliomisc.module		"INCLUDE">
<!ENTITY % blockquote.module		"INCLUDE">
<!ENTITY % bookbiblio.module		"INCLUDE">
<!ENTITY % bridgehead.module		"INCLUDE">
<!--       caution.module		use admon.module-->
<!ENTITY % citation.module		"INCLUDE">
<!ENTITY % citerefentry.content.module	"INCLUDE">
<!ENTITY % citerefentry.module		"INCLUDE">
<!ENTITY % citetitle.module		"INCLUDE">
<!ENTITY % city.module			"INCLUDE">
<!ENTITY % classname.module		"INCLUDE">
<!ENTITY % cmdsynopsis.content.module	"INCLUDE">
<!ENTITY % cmdsynopsis.module		"INCLUDE">
<!ENTITY % collab.module		"INCLUDE">
<!ENTITY % collab.content.module	"INCLUDE">
<!ENTITY % collabname.module		"INCLUDE">
<!ENTITY % command.module		"INCLUDE">
<!ENTITY % comment.module		"INCLUDE">
<!ENTITY % computeroutput.module	"INCLUDE">
<!ENTITY % confdates.module		"INCLUDE">
<!ENTITY % confgroup.module		"INCLUDE">
<!ENTITY % confgroup.content.module	"INCLUDE">
<!ENTITY % confnum.module		"INCLUDE">
<!ENTITY % confsponsor.module		"INCLUDE">
<!ENTITY % conftitle.module		"INCLUDE">
<!ENTITY % contractnum.module		"INCLUDE">
<!ENTITY % contractsponsor.module	"INCLUDE">
<!ENTITY % contrib.module		"INCLUDE">
<!ENTITY % copyright.module		"INCLUDE">
<!ENTITY % copyright.content.module	"INCLUDE">
<!ENTITY % corpauthor.module		"INCLUDE">
<!ENTITY % corpname.module		"INCLUDE">
<!ENTITY % country.module		"INCLUDE">
<!ENTITY % database.module		"INCLUDE">
<!ENTITY % date.module			"INCLUDE">
<!ENTITY % docinfo.content.module	"INCLUDE">
<!ENTITY % edition.module		"INCLUDE">
<!ENTITY % editor.module		"INCLUDE">
<!ENTITY % email.module			"INCLUDE">
<!ENTITY % emphasis.module		"INCLUDE">
<!ENTITY % epigraph.module		"INCLUDE">
<!ENTITY % equation.module		"INCLUDE">
<!ENTITY % errorname.module		"INCLUDE">
<!ENTITY % errortype.module		"INCLUDE">
<!ENTITY % example.module		"INCLUDE">
<!ENTITY % fax.module			"INCLUDE">
<!ENTITY % figure.module		"INCLUDE">
<!ENTITY % filename.module		"INCLUDE">
<!ENTITY % firstname.module		"INCLUDE">
<!ENTITY % firstterm.module		"INCLUDE">
<!ENTITY % footnote.module		"INCLUDE">
<!ENTITY % footnoteref.module		"INCLUDE">
<!ENTITY % foreignphrase.module		"INCLUDE">
<!ENTITY % formalpara.module		"INCLUDE">
<!ENTITY % funcdef.module		"INCLUDE">
<!ENTITY % funcparams.module		"INCLUDE">
<!ENTITY % funcsynopsis.content.module	"INCLUDE">
<!ENTITY % funcsynopsis.module		"INCLUDE">
<!ENTITY % funcsynopsisinfo.module	"INCLUDE">
<!ENTITY % function.module		"INCLUDE">
<!ENTITY % glossdef.module		"INCLUDE">
<!ENTITY % glossentry.content.module	"INCLUDE">
<!ENTITY % glossentry.module		"INCLUDE">
<!ENTITY % glosslist.module		"INCLUDE">
<!ENTITY % glosssee.module		"INCLUDE">
<!ENTITY % glossseealso.module		"INCLUDE">
<!ENTITY % glossterm.module		"INCLUDE">
<!ENTITY % graphic.module		"INCLUDE">
<!ENTITY % group.module			"INCLUDE">
<!ENTITY % hardware.module		"INCLUDE">
<!ENTITY % highlights.module		"INCLUDE">
<!ENTITY % holder.module		"INCLUDE">
<!ENTITY % honorific.module		"INCLUDE">
<!ENTITY % indexterm.content.module	"INCLUDE">
<!ENTITY % indexterm.module		"INCLUDE">
<!ENTITY % informalequation.module	"INCLUDE">
<!ENTITY % informalexample.module	"INCLUDE">
<!ENTITY % informaltable.module		"INCLUDE">
<!ENTITY % inlineequation.module	"INCLUDE">
<!ENTITY % inlinegraphic.module		"INCLUDE">
<!ENTITY % interface.module		"INCLUDE">
<!ENTITY % interfacedefinition.module	"INCLUDE">
<!ENTITY % invpartnumber.module		"INCLUDE">
<!ENTITY % isbn.module			"INCLUDE">
<!ENTITY % issn.module			"INCLUDE">
<!ENTITY % issuenum.module		"INCLUDE">
<!ENTITY % itemizedlist.module		"INCLUDE">
<!ENTITY % jobtitle.module		"INCLUDE">
<!ENTITY % keycap.module		"INCLUDE">
<!ENTITY % keycode.module		"INCLUDE">
<!ENTITY % keysym.module		"INCLUDE">
<!ENTITY % legalnotice.module		"INCLUDE">
<!ENTITY % lineage.module		"INCLUDE">
<!ENTITY % lineannotation.module	"INCLUDE">
<!ENTITY % link.module			"INCLUDE">
<!ENTITY % listitem.module		"INCLUDE">
<!ENTITY % literal.module		"INCLUDE">
<!ENTITY % literallayout.module		"INCLUDE">
<!ENTITY % manvolnum.module		"INCLUDE">
<!ENTITY % markup.module		"INCLUDE">
<!ENTITY % medialabel.module		"INCLUDE">
<!ENTITY % member.module		"INCLUDE">
<!ENTITY % modespec.module		"INCLUDE">
<!ENTITY % modespec.module		"INCLUDE">
<!ENTITY % msg.module			"INCLUDE">
<!ENTITY % msgaud.module		"INCLUDE">
<!ENTITY % msgentry.module		"INCLUDE">
<!ENTITY % msgexplan.module		"INCLUDE">
<!ENTITY % msginfo.module		"INCLUDE">
<!ENTITY % msglevel.module		"INCLUDE">
<!ENTITY % msgmain.module		"INCLUDE">
<!ENTITY % msgorig.module		"INCLUDE">
<!ENTITY % msgrel.module		"INCLUDE">
<!ENTITY % msgset.content.module	"INCLUDE">
<!ENTITY % msgset.module		"INCLUDE">
<!ENTITY % msgsub.module		"INCLUDE">
<!ENTITY % msgtext.module		"INCLUDE">
<!--       note.module			use admon.module-->
<!ENTITY % olink.module			"INCLUDE">
<!ENTITY % option.module		"INCLUDE">
<!ENTITY % optional.module		"INCLUDE">
<!ENTITY % orderedlist.module		"INCLUDE">
<!ENTITY % orgdiv.module		"INCLUDE">
<!ENTITY % orgname.module		"INCLUDE">
<!ENTITY % otheraddr.module		"INCLUDE">
<!ENTITY % othercredit.module		"INCLUDE">
<!ENTITY % othername.module		"INCLUDE">
<!ENTITY % pagenums.module		"INCLUDE">
<!ENTITY % para.module			"INCLUDE">
<!ENTITY % paramdef.module		"INCLUDE">
<!ENTITY % parameter.module		"INCLUDE">
<!ENTITY % person.ident.module		"INCLUDE">
<!ENTITY % phone.module			"INCLUDE">
<!ENTITY % pob.module			"INCLUDE">
<!ENTITY % postcode.module		"INCLUDE">
<!--       primary.module		use primsecter.module-->
<!ENTITY % primsecter.module		"INCLUDE">
<!ENTITY % printhistory.module		"INCLUDE">
<!ENTITY % procedure.content.module	"INCLUDE">
<!ENTITY % procedure.module		"INCLUDE">
<!ENTITY % productname.module		"INCLUDE">
<!ENTITY % productnumber.module		"INCLUDE">
<!ENTITY % programlisting.module	"INCLUDE">
<!ENTITY % property.module		"INCLUDE">
<!ENTITY % pubdate.module		"INCLUDE">
<!ENTITY % publisher.module		"INCLUDE">
<!ENTITY % publisher.content.module	"INCLUDE">
<!ENTITY % publishername.module		"INCLUDE">
<!ENTITY % pubsnumber.module		"INCLUDE">
<!ENTITY % quote.module			"INCLUDE">
<!ENTITY % refentrytitle.module		"INCLUDE">
<!ENTITY % releaseinfo.module		"INCLUDE">
<!ENTITY % replaceable.module		"INCLUDE">
<!ENTITY % returnvalue.module		"INCLUDE">
<!ENTITY % revhistory.module		"INCLUDE">
<!ENTITY % revhistory.content.module	"INCLUDE">
<!ENTITY % revision.module		"INCLUDE">
<!ENTITY % revnumber.module		"INCLUDE">
<!ENTITY % revremark.module		"INCLUDE">
<!ENTITY % screen.module		"INCLUDE">
<!ENTITY % screeninfo.module		"INCLUDE">
<!ENTITY % screenshot.content.module	"INCLUDE">
<!ENTITY % screenshot.module		"INCLUDE">
<!--       secondary.module		use primsecter.module-->
<!--       see.module			use seeseealso.module-->
<!--       seealso.module		use seeseealso.module-->
<!ENTITY % seeseealso.module		"INCLUDE">
<!ENTITY % seg.module			"INCLUDE">
<!ENTITY % seglistitem.module		"INCLUDE">
<!ENTITY % segmentedlist.content.module	"INCLUDE">
<!ENTITY % segmentedlist.module		"INCLUDE">
<!ENTITY % segtitle.module		"INCLUDE">
<!ENTITY % seriesinfo.module		"INCLUDE">
<!ENTITY % seriesvolnums.module		"INCLUDE">
<!ENTITY % sgmltag.module		"INCLUDE">
<!ENTITY % shortaffil.module		"INCLUDE">
<!ENTITY % sidebar.module		"INCLUDE">
<!ENTITY % simpara.module		"INCLUDE">
<!ENTITY % simplelist.content.module	"INCLUDE">
<!ENTITY % simplelist.module		"INCLUDE">
<!ENTITY % ssscript.module		"INCLUDE">
<!ENTITY % state.module			"INCLUDE">
<!ENTITY % step.module			"INCLUDE">
<!ENTITY % street.module		"INCLUDE">
<!ENTITY % structfield.module		"INCLUDE">
<!ENTITY % structname.module		"INCLUDE">
<!ENTITY % substeps.module		"INCLUDE">
<!--       subscript.module		use ssscript.module-->
<!ENTITY % subtitle.module		"INCLUDE">
<!--       superscript.module		use ssscript.module-->
<!ENTITY % surname.module		"INCLUDE">
<!ENTITY % symbol.module		"INCLUDE">
<!ENTITY % synopfragment.module		"INCLUDE">
<!ENTITY % synopfragmentref.module	"INCLUDE">
<!ENTITY % synopsis.module		"INCLUDE">
<!ENTITY % systemitem.module		"INCLUDE">
<!ENTITY % table.module			"INCLUDE">
<!ENTITY % term.module			"INCLUDE">
<!--       tertiary.module		use primsecter.module-->
<!ENTITY % title.module			"INCLUDE">
<!ENTITY % titleabbrev.module		"INCLUDE">
<!ENTITY % token.module			"INCLUDE">
<!ENTITY % trademark.module		"INCLUDE">
<!ENTITY % type.module			"INCLUDE">
<!ENTITY % ulink.module			"INCLUDE">
<!ENTITY % userinput.module		"INCLUDE">
<!ENTITY % varargs.module		"INCLUDE">
<!ENTITY % variablelist.content.module	"INCLUDE">
<!ENTITY % variablelist.module		"INCLUDE">
<!ENTITY % varlistentry.module		"INCLUDE">
<!ENTITY % void.module			"INCLUDE">
<!ENTITY % volumenum.module		"INCLUDE">
<!--       warning.module		use admon.module-->
<!ENTITY % wordasword.module		"INCLUDE">
<!ENTITY % xref.module			"INCLUDE">
<!ENTITY % year.module			"INCLUDE">

<!-- ...................................................................... -->
<!-- Entities for element classes and mixtures ............................ -->

<!-- Object-level classes ................................................. -->

<!ENTITY % local.list.class "">
<!ENTITY % list.class
		"GlossList|ItemizedList|OrderedList|SegmentedList
		|SimpleList|VariableList %local.list.class;">

<!ENTITY % local.admon.class "">
<!ENTITY % admon.class
		"Caution|Important|Note|Tip|Warning %local.admon.class;">

<!ENTITY % local.linespecific.class "">
<!ENTITY % linespecific.class
		"LiteralLayout|ProgramListing|Screen|ScreenShot
		%local.linespecific.class;">

<!ENTITY % local.synop.class "">
<!ENTITY % synop.class
		"Synopsis|CmdSynopsis|FuncSynopsis %local.synop.class;">

<!ENTITY % local.para.class "">
<!ENTITY % para.class
		"FormalPara|Para|SimPara %local.para.class;">

<!ENTITY % local.informal.class "">
<!ENTITY % informal.class
		"BlockQuote|InformalEquation|InformalExample|InformalTable
		|Graphic %local.informal.class;">

<!ENTITY % local.formal.class "">
<!ENTITY % formal.class
		"Equation|Example|Figure|Table %local.formal.class;">

<!ENTITY % local.compound.class "">
<!ENTITY % compound.class
		"MsgSet|Procedure|Sidebar %local.compound.class;">

<!ENTITY % local.genobj.class "">
<!ENTITY % genobj.class
		"Anchor|BridgeHead|Comment|Highlights
		%local.genobj.class;">

<!ENTITY % local.descobj.class "">
<!ENTITY % descobj.class
		"Abstract|AuthorBlurb|Epigraph
		%local.descobj.class;">

<!-- Character-level classes .............................................. -->

<!ENTITY % local.ndxterm.class "">
<!ENTITY % ndxterm.class
		"IndexTerm %local.ndxterm.class;">

<!ENTITY % local.xref.char.class "">
<!ENTITY % xref.char.class
		"FootnoteRef|XRef %local.xref.char.class;">

<!ENTITY % local.word.char.class "">
<!ENTITY % word.char.class
		"Abbrev|Acronym|Citation|CiteTitle|CiteRefEntry|Emphasis
		|FirstTerm|ForeignPhrase|GlossTerm|Footnote|Markup|Quote
		|SGMLTag|Trademark|WordAsWord %local.word.char.class;">

<!ENTITY % local.link.char.class "">
<!ENTITY % link.char.class
		"Link|OLink|ULink %local.link.char.class;">

<!ENTITY % local.cptr.char.class "">
<!ENTITY % cptr.char.class
		"Action|Application|ClassName|Command|ComputerOutput
		|Database|ErrorName|ErrorType|Filename|Function|Hardware
		|Interface|InterfaceDefinition|KeyCap|KeyCode|KeySym
		|Literal|MediaLabel|MsgText|Option|Optional|Parameter
		|Property|Replaceable|ReturnValue|StructField|StructName
		|Symbol|SystemItem|Token|Type|UserInput
		%local.cptr.char.class;">

<!ENTITY % local.base.char.class "">
<!ENTITY % base.char.class
		"Anchor %local.base.char.class;">

<!ENTITY % local.docinfo.char.class "">
<!ENTITY % docinfo.char.class
		"Author|AuthorInitials|CorpAuthor|ModeSpec|OtherCredit
		|ProductName|ProductNumber|RevHistory
		%local.docinfo.char.class;">

<!ENTITY % local.other.char.class "">
<!ENTITY % other.char.class
		"Comment|Subscript|Superscript %local.other.char.class;">

<!ENTITY % local.inlineobj.char.class "">
<!ENTITY % inlineobj.char.class
		"InlineGraphic|InlineEquation %local.inlineobj.char.class;">

<!-- Redeclaration placeholder ............................................ -->

<![ %dbpool.redecl.module; [
<!ENTITY % rdbpool PUBLIC
"-//Davenport//ELEMENTS DocBook Information Pool Redeclarations//EN">
%rdbpool;
<!--end of dbpool.redecl.module-->]]>

<!-- Object-level mixtures ................................................ -->

<!--
[X = all, . = some]   list admn line synp para infm form cmpd gen  desc
Component mixture       X    X    X    X    X    X    X    X    X    X
Sidebar mixture         X    X    X    X    X    X    X    .    X
Footnote mixture        X         X    X    X    X
Example mixture         X         X    X    X    X
Highlights mixture      X    X              X
Paragraph mixture       X         X    X         X
Admonition mixture      X         X    X    X    X    X    .    .
Figure mixture                    X    X         X
Table entry mixture     X    X    X         X    .
Glossary def mixture    X         X    X    X    X         .
Legal notice mixture    X    X    X         X    .
-->

<!ENTITY % local.component.mix "">
<!ENTITY % component.mix
		"%list.class;		|%admon.class;
		|%linespecific.class;	|%synop.class;
		|%para.class;		|%informal.class;
		|%formal.class;		|%compound.class;
		|%genobj.class;		|%descobj.class;
		%local.component.mix;">

<!ENTITY % local.sidebar.mix "">
<!ENTITY % sidebar.mix
		"%list.class;		|%admon.class;
		|%linespecific.class;	|%synop.class;
		|%para.class;		|%informal.class;
		|%formal.class;		|Procedure
		|%genobj.class;
		%local.sidebar.mix;">

<!ENTITY % local.footnote.mix "">
<!ENTITY % footnote.mix
		"%list.class;
		|%linespecific.class;	|%synop.class;
		|%para.class;		|%informal.class;
		%local.footnote.mix;">

<!ENTITY % local.example.mix "">
<!ENTITY % example.mix
		"%list.class;
		|%linespecific.class;	|%synop.class;
		|%para.class;		|%informal.class;
		%local.example.mix;">

<!ENTITY % local.highlights.mix "">
<!ENTITY % highlights.mix
		"%list.class;		|%admon.class;
		|%para.class;
		%local.highlights.mix;">

<!-- %synop.class; is already included in para.char.mix because synopses
     used inside paragraph contexts are "inline" synopses -->
<!ENTITY % local.para.mix "">
<!ENTITY % para.mix
		"%list.class;
		|%linespecific.class;
					|%informal.class;
		%local.para.mix;">

<!ENTITY % local.admon.mix "">
<!ENTITY % admon.mix
		"%list.class;
		|%linespecific.class;	|%synop.class;
		|%para.class;		|%informal.class;
		|%formal.class;		|Procedure|Sidebar
		|Anchor|BridgeHead|Comment
		%local.admon.mix;">

<!ENTITY % local.figure.mix "">
<!ENTITY % figure.mix
		"%linespecific.class;	|%synop.class;
					|%informal.class;
		%local.figure.mix;">

<!ENTITY % local.tabentry.mix "">
<!ENTITY % tabentry.mix
		"%list.class;		|%admon.class;
		|%linespecific.class;
		|%para.class;		|Graphic
		%local.tabentry.mix;">

<!ENTITY % local.glossdef.mix "">
<!ENTITY % glossdef.mix
		"%list.class;
		|%linespecific.class;	|%synop.class;
		|%para.class;		|%informal.class;
		|Comment
		%local.glossdef.mix;">

<!ENTITY % local.legalnotice.mix "">
<!ENTITY % legalnotice.mix
		"%list.class;		|%admon.class;
		|%linespecific.class;
		|%para.class;		|BlockQuote
		%local.legalnotice.mix;">

<!-- Character-level mixtures ............................................. -->

<!ENTITY % local.ubiq.mix "">
<!ENTITY % ubiq.mix
		"%ndxterm.class;|BeginPage %local.ubiq.mix;">

<!--
[X = all, . = some]   #PCDATA xref word link cptr base dnfo othr inob
Paragraph char mixture     X    X    X    X    X    X    X    X    X
Inline char mixture        X    X    X    X    X    X    X    X
Synopsis char mixture      X    X    X    X    X    X    X    X
Computer char mixture      X              X    X    X         X
Sub/superscr char mixture  X         .    X    .    X         X
Phrase char mixture        X              X         X         X
-->

<!-- Note that synop.class is not usually used for *.char.mixes,
     but is used here because synopses used inside paragraph
     contexts are "inline" synopses -->
<!ENTITY % local.para.char.mix "">
<!ENTITY % para.char.mix
		"#PCDATA
		|%xref.char.class;	|%word.char.class;
		|%link.char.class;	|%cptr.char.class;
		|%base.char.class;	|%docinfo.char.class;
		|%other.char.class;	|%inlineobj.char.class;
		|%synop.class;
		%local.para.char.mix;">

<!ENTITY % local.inline.char.mix "">
<!ENTITY % inline.char.mix
		"#PCDATA
		|%xref.char.class;	|%word.char.class;
		|%link.char.class;	|%cptr.char.class;
		|%base.char.class;	|%docinfo.char.class;
		|%other.char.class;
		%local.inline.char.mix;">

<!ENTITY % local.synop.char.mix "">
<!ENTITY % synop.char.mix
		"#PCDATA
		|%xref.char.class;	|%word.char.class;
		|%link.char.class;	|%cptr.char.class;
		|%base.char.class;	|%docinfo.char.class;
		|%other.char.class;
		%local.synop.char.mix;">

<!ENTITY % local.cptr.char.mix "">
<!ENTITY % cptr.char.mix
		"#PCDATA
		|%link.char.class;	|%cptr.char.class;
		|%base.char.class;
		|%other.char.class;
		%local.cptr.char.mix;">

<!ENTITY % local.ssscript.char.mix "">
<!ENTITY % ssscript.char.mix
		"#PCDATA
		                        |Emphasis
		|%link.char.class;      |Replaceable
		|%base.char.class;
		|%other.char.class;
		%local.ssscript.char.mix;">

<!ENTITY % local.phrase.char.mix "">
<!ENTITY % phrase.char.mix
		"#PCDATA
		|%link.char.class;
		|%base.char.class;
		|%other.char.class;
		%local.phrase.char.mix;">

<!--ENTITY % person.ident.mix (see Document Information section, below)-->

<!-- ...................................................................... -->
<!-- Entities for content models .......................................... -->

<!ENTITY % formalobject.title.content "Title, TitleAbbrev?">

<!ENTITY % equation.content "(Graphic+)">

<!ENTITY % inlineequation.content "(Graphic+)">

<!ENTITY % programlisting.content "LineAnnotation | %inline.char.mix;">

<!ENTITY % screen.content "LineAnnotation | %inline.char.mix;">

<!-- ...................................................................... -->
<!-- Entities for attributes and attribute components ..................... -->


<!ENTITY % id.attrib
	--Id: unique identifier of element--
	"Id		ID		#IMPLIED">

<!ENTITY % idreq.attrib
	--Id: unique identifier of element; a value must be supplied--
	"Id		ID		#REQUIRED">

<!ENTITY % lang.attrib
	--Lang: indicator of language in which element is written, for
	translation, character set management, etc.--
	"Lang		CDATA		#IMPLIED">

<!ENTITY % remap.attrib
	--Remap: previous role of element before conversion--
	"Remap		CDATA		#IMPLIED">

<!ENTITY % role.attrib
	--Role: new role of element in local environment--
	"Role		CDATA		#IMPLIED">

<!ENTITY % xreflabel.attrib
	--XRefLabel: alternate labeling string for XRef text generation--
	"XRefLabel	CDATA		#IMPLIED">

<!ENTITY % linkend.attrib
	--Linkend: link to related information--
	"Linkend	IDREF		#IMPLIED">

<!ENTITY % linkendreq.attrib
	--Linkend: required link to related information--
	"Linkend	IDREF		#REQUIRED">

<!ENTITY % linkends.attrib
	--Linkends: link to one or more sets of related information--
	"Linkends	IDREFS		#IMPLIED">

<!ENTITY % linkendsreq.attrib
	--Linkends: required link to one or more sets of related information--
	"Linkends	IDREFS		#REQUIRED">

<!ENTITY % label.attrib
	--Label: number or identifying string--
	"Label		CDATA		#IMPLIED">

<!ENTITY % pagenum.attrib
	--Pagenum: number of page on which element appears--
	"Pagenum	CDATA		#IMPLIED">

<!ENTITY % moreinfo.attrib
	--MoreInfo: whether element's content has an associated RefEntry--
	"MoreInfo	(RefEntry|None)	None">

<!ENTITY % linespecific.attrib
	"Format		NOTATION
			(linespecific)	linespecific">

<!ENTITY % local.common.attrib "">
<!ENTITY % common.attrib
	"%id.attrib;
	%lang.attrib;
	%remap.attrib;
	%role.attrib;
	%xreflabel.attrib;
	%local.common.attrib;"
>

<!ENTITY % idreq.common.attrib
	"%idreq.attrib;
	%lang.attrib;
	%remap.attrib;
	%role.attrib;
	%xreflabel.attrib;
	%local.common.attrib;"
>

<!ENTITY % local.graphic.attrib "">
<!ENTITY % graphic.attrib
	"Entityref	ENTITY		#IMPLIED
	Fileref 	CDATA		#IMPLIED
	Format		NOTATION
			(%notation.class;)
					#IMPLIED
	SrcCredit	CDATA		#IMPLIED
	%local.graphic.attrib;"
>

<!ENTITY % local.mark.attrib "">
<!ENTITY % mark.attrib
	"Mark		CDATA		#IMPLIED
	%local.mark.attrib;"
>

<!ENTITY % yesorno.attvals	"NUMBER">
<!ENTITY % yes.attval		"1">
<!ENTITY % no.attval		"0">

<!-- ...................................................................... -->
<!-- Title and bibliographic elements ..................................... -->

<![ %title.module; [
<!ENTITY % local.title.attrib "">
<!ELEMENT Title - - ((%inline.char.mix;)+)>
<!ATTLIST Title
		%common.attrib;
		%pagenum.attrib;
		%local.title.attrib;
>
<!--end of title.module-->]]>

<![ %titleabbrev.module; [
<!ENTITY % local.titleabbrev.attrib "">
<!ELEMENT TitleAbbrev - - ((%inline.char.mix;)+)>
<!ATTLIST TitleAbbrev
		%common.attrib;
		%local.titleabbrev.attrib;
>
<!--end of titleabbrev.module-->]]>

<![ %subtitle.module; [
<!ENTITY % local.subtitle.attrib "">
<!ELEMENT SubTitle - - ((%inline.char.mix;)+)>
<!ATTLIST SubTitle
		%common.attrib;
		%local.subtitle.attrib;
>
<!--end of subtitle.module-->]]>

<!-- The bibliographic elements are typically used in the document
     hierarchy. They do not appear in content models of information
     pool elements.  See also the document information elements,
     below. -->

<![ %biblioentry.content.module; [

<!-- This model of BiblioEntry produces info in the order "title, author";
     TEI prefers "author, title". -->

<![ %biblioentry.module; [
<!ENTITY % local.biblioentry.attrib "">
<!ELEMENT BiblioEntry - - (BiblioMisc?, (ArtHeader | BookBiblio | SeriesInfo),
		BiblioMisc?)>
<!ATTLIST BiblioEntry
		%common.attrib;
		%local.biblioentry.attrib;
>
<!--end of biblioentry.module-->]]>

<![ %bibliomisc.module; [
<!ENTITY % local.bibliomisc.attrib "">
<!ELEMENT BiblioMisc - - (#PCDATA)>
<!ATTLIST BiblioMisc
		%common.attrib;
		%local.bibliomisc.attrib;
>
<!--end of bibliomisc.module-->]]>
<!--end of biblioentry.content.module-->]]>

<![ %bookbiblio.module; [
<!ENTITY % local.bookbiblio.attrib "">
<!ELEMENT BookBiblio - - ((Title, TitleAbbrev?)?, SubTitle?, Edition?,
		AuthorGroup+, ((ISBN, VolumeNum?) | (ISSN, VolumeNum?,
		IssueNum?, PageNums?))?, InvPartNumber?, ProductNumber?,
		ProductName?, PubsNumber?, ReleaseInfo?, PubDate*,
		Publisher*, Copyright?, SeriesInfo?, Abstract*, ConfGroup*,
		(ContractNum | ContractSponsor)*, PrintHistory?, RevHistory?)
		-(%ubiq.mix;)>
<!ATTLIST BookBiblio
		%common.attrib;
		%local.bookbiblio.attrib;
>
<!--end of bookbiblio.module-->]]>

<![ %seriesinfo.module; [
<!ENTITY % local.seriesinfo.attrib "">
<!ELEMENT SeriesInfo - - ((%formalobject.title.content;), SubTitle?, 
		AuthorGroup*, ISBN?, VolumeNum?, IssueNum?, SeriesVolNums, 
		PubDate*, Publisher*, Copyright?) -(%ubiq.mix;)>
<!ATTLIST SeriesInfo
		%common.attrib;
		%local.seriesinfo.attrib;
>
<!--end of seriesinfo.module-->]]>

<![ %artheader.module; [
<!ENTITY % local.artheader.attrib "">
<!ELEMENT ArtHeader - - ((%formalobject.title.content;), SubTitle?, 
		AuthorGroup+, BookBiblio?, ArtPageNums, Abstract*, ConfGroup*,
		(ContractNum | ContractSponsor)*)>
<!ATTLIST ArtHeader
		%common.attrib;
		%local.artheader.attrib;
>
<!--end of artheader.module-->]]>

<!-- ...................................................................... -->
<!-- Compound (section-ish) elements ...................................... -->

<!-- Message set ...................... -->

<![ %msgset.content.module; [
<![ %msgset.module; [
<!ENTITY % local.msgset.attrib "">
<!ELEMENT MsgSet - - (MsgEntry+)>
<!ATTLIST MsgSet
		%common.attrib;
		%local.msgset.attrib;
>
<!--end of msgset.module-->]]>

<![ %msgentry.module; [
<!ENTITY % local.msgentry.attrib "">
<!ELEMENT MsgEntry - - (Msg+, MsgInfo?, MsgExplan*)>
<!ATTLIST MsgEntry
		%common.attrib;
		%local.msgentry.attrib;
>
<!--end of msgentry.module-->]]>

<![ %msg.module; [
<!ENTITY % local.msg.attrib "">
<!ELEMENT Msg - - (Title?, MsgMain, (MsgSub | MsgRel)*)>
<!ATTLIST Msg
		%common.attrib;
		%local.msg.attrib;
>
<!--end of msg.module-->]]>

<![ %msgmain.module; [
<!ENTITY % local.msgmain.attrib "">
<!ELEMENT MsgMain - - (Title?, MsgText)>
<!ATTLIST MsgMain
		%common.attrib;
		%local.msgmain.attrib;
>
<!--end of msgmain.module-->]]>

<![ %msgsub.module; [
<!ENTITY % local.msgsub.attrib "">
<!ELEMENT MsgSub - - (Title?, MsgText)>
<!ATTLIST MsgSub
		%common.attrib;
		%local.msgsub.attrib;
>
<!--end of msgsub.module-->]]>

<![ %msgrel.module; [
<!ENTITY % local.msgrel.attrib "">
<!ELEMENT MsgRel - - (Title?, MsgText)>
<!ATTLIST MsgRel
		%common.attrib;
		%local.msgrel.attrib;
>
<!--end of msgrel.module-->]]>

<!--ELEMENT MsgText (defined in the Inlines section, below)-->

<![ %msginfo.module; [
<!ENTITY % local.msginfo.attrib "">
<!ELEMENT MsgInfo - - ((MsgLevel | MsgOrig | MsgAud)*)>
<!ATTLIST MsgInfo
		%common.attrib;
		%local.msginfo.attrib;
>
<!--end of msginfo.module-->]]>

<![ %msglevel.module; [
<!ENTITY % local.msglevel.attrib "">
<!ELEMENT MsgLevel - - (#PCDATA)>
<!ATTLIST MsgLevel
		%common.attrib;
		%local.msglevel.attrib;
>
<!--end of msglevel.module-->]]>

<![ %msgorig.module; [
<!ENTITY % local.msgorig.attrib "">
<!ELEMENT MsgOrig - - (#PCDATA)>
<!ATTLIST MsgOrig
		%common.attrib;
		%local.msgorig.attrib;
>
<!--end of msgorig.module-->]]>

<![ %msgaud.module; [
<!ENTITY % local.msgaud.attrib "">
<!ELEMENT MsgAud - - (#PCDATA)>
<!ATTLIST MsgAud
		%common.attrib;
		%local.msgaud.attrib;
>
<!--end of msgaud.module-->]]>

<![ %msgexplan.module; [
<!ENTITY % local.msgexplan.attrib "">
<!ELEMENT MsgExplan - - (Title?, (%component.mix;)+)>
<!ATTLIST MsgExplan
		%common.attrib;
		%local.msgexplan.attrib;
>
<!--end of msgexplan.module-->]]>
<!--end of msgset.content.module-->]]>

<!-- Procedure ........................ -->

<![ %procedure.content.module; [
<![ %procedure.module; [
<!ENTITY % local.procedure.attrib "">
<!ELEMENT Procedure - - ((%formalobject.title.content;)?,
                         (%component.mix;)*, Step+)>
<!ATTLIST Procedure
		%common.attrib;
		%local.procedure.attrib;
>
<!--end of procedure.module-->]]>

<![ %step.module; [
<!ENTITY % local.step.attrib "">
<!ELEMENT Step - - (Title?, (((%component.mix;)+, (SubSteps,
		(%component.mix;)*)?) | (SubSteps, (%component.mix;)*)))>
<!ATTLIST Step
		%common.attrib;

		--Performance: whether step must be performed--
		Performance	(Optional
				|Required)	Required -- not #REQUIRED! --
		%local.step.attrib;
>
<!--end of step.module-->]]>

<![ %substeps.module; [
<!ENTITY % local.substeps.attrib "">
<!ELEMENT SubSteps - - (Step+)>
<!ATTLIST SubSteps
		%common.attrib;

		--Performance: whether whole set of substeps must be
		performed--
		Performance	(Optional
				|Required)	Required -- not #REQUIRED! --
		%local.substeps.attrib;
>
<!--end of substeps.module-->]]>
<!--end of procedure.content.module-->]]>

<!-- Sidebar .......................... -->

<![ %sidebar.module; [
<!ENTITY % local.sidebar.attrib "">
<!ELEMENT Sidebar - - ((%formalobject.title.content)?, (%sidebar.mix;)+)>
<!ATTLIST Sidebar
		%common.attrib;
		%local.sidebar.attrib;
>
<!--end of sidebar.module-->]]>

<!-- ...................................................................... -->
<!-- Paragraph-related elements ........................................... -->

<![ %abstract.module; [
<!ENTITY % local.abstract.attrib "">
<!ELEMENT Abstract - - (Title?, (%para.class;)+)>
<!ATTLIST Abstract
		%common.attrib;
		%local.abstract.attrib;
>
<!--end of abstract.module-->]]>

<![ %authorblurb.module; [
<!ENTITY % local.authorblurb.attrib "">
<!ELEMENT AuthorBlurb - - (Title?, (%para.class;)+)>
<!ATTLIST AuthorBlurb
		%common.attrib;
		%local.authorblurb.attrib;
>
<!--end of authorblurb.module-->]]>

<![ %blockquote.module; [
<!ENTITY % local.blockquote.attrib "">
<!ELEMENT BlockQuote - - (Title?, (%component.mix;)+)>
<!ATTLIST BlockQuote
		%common.attrib;
		%local.blockquote.attrib;
>
<!--end of blockquote.module-->]]>

<![ %bridgehead.module; [
<!ENTITY % local.bridgehead.attrib "">
<!ELEMENT BridgeHead - - ((%inline.char.mix;)+)>
<!ATTLIST BridgeHead
		%common.attrib;
		Renderas	(Other
				|Sect1
				|Sect2
				|Sect3
				|Sect4
				|Sect5)		#IMPLIED
		%local.bridgehead.attrib;
>
<!--end of bridgehead.module-->]]>

<![ %comment.module; [
<!ENTITY % local.comment.attrib "">
<!ELEMENT Comment - - ((%inline.char.mix;)+) -(%ubiq.mix;)>
<!ATTLIST Comment
		%common.attrib;
		%local.comment.attrib;
>
<!--end of comment.module-->]]>

<![ %epigraph.module; [
<!ENTITY % local.epigraph.attrib "">
<!ELEMENT Epigraph - - ((%para.class;)+)>
<!ATTLIST Epigraph
		%common.attrib;
		%local.epigraph.attrib;
>
<!--end of epigraph.module-->]]>

<![ %footnote.module; [
<!ENTITY % local.footnote.attrib "">
<!ELEMENT Footnote - - ((%footnote.mix;)+) -(Footnote)>
<!ATTLIST Footnote
		%common.attrib;
		%local.footnote.attrib;
>
<!--end of footnote.module-->]]>

<![ %highlights.module; [
<!ENTITY % local.highlights.attrib "">
<!ELEMENT Highlights - - ((%highlights.mix;)+) -(%ubiq.mix;)>
<!ATTLIST Highlights
		%common.attrib;
		%local.highlights.attrib;
>
<!--end of highlights.module-->]]>

<![ %formalpara.module; [
<!ENTITY % local.formalpara.attrib "">
<!ELEMENT FormalPara - - (Title, Para)>
<!ATTLIST FormalPara
		%common.attrib;
		%local.formalpara.attrib;
>
<!--end of formalpara.module-->]]>

<![ %para.module; [
<!ENTITY % local.para.attrib "">
<!ELEMENT Para - - ((%para.char.mix; | %para.mix;)+)>
<!ATTLIST Para
		%common.attrib;
		%local.para.attrib;
>
<!--end of para.module-->]]>

<![ %simpara.module; [
<!ENTITY % local.simpara.attrib "">
<!ELEMENT SimPara - - ((%para.char.mix;)+)>
<!ATTLIST SimPara
		%common.attrib;
		%local.simpara.attrib;
>
<!--end of simpara.module-->]]>

<![ %admon.module; [
<!ENTITY % local.admon.attrib "">
<!ELEMENT (%admon.class;) - - (Title?, (%admon.mix;)+) -(%admon.class;)>
<!ATTLIST (%admon.class;)
		%common.attrib;
		%local.admon.attrib;
>
<!--end of admon.module-->]]>

<!-- ...................................................................... -->
<!-- Lists ................................................................ -->

<!-- GlossList ........................ -->

<![ %glosslist.module; [
<!ENTITY % local.glosslist.attrib "">
<!ELEMENT GlossList - - (GlossEntry+)>
<!ATTLIST GlossList
		%common.attrib;
		%local.glosslist.attrib;
>
<!--end of glosslist.module-->]]>

<![ %glossentry.content.module; [
<![ %glossentry.module; [
<!ENTITY % local.glossentry.attrib "">
<!ELEMENT GlossEntry - - (GlossTerm, Acronym?, Abbrev?, (GlossSee|GlossDef+))>
<!ATTLIST GlossEntry
		%common.attrib;

		--SortAs: alternate sort string for automatically
		alphabetized set of glossary entries--
		SortAs		CDATA		#IMPLIED
		%local.glossentry.attrib;
>
<!--end of glossentry.module-->]]>

<!--ELEMENT GlossTerm (defined in the Inlines section, below)-->

<![ %glossdef.module; [
<!ENTITY % local.glossdef.attrib "">
<!ELEMENT GlossDef - - ((%glossdef.mix;)+, GlossSeeAlso*)>
<!ATTLIST GlossDef
		%common.attrib;

		--Subject: one or more subject area keywords for searching--
		Subject		CDATA		#IMPLIED
		%local.glossdef.attrib;
>
<!--end of glossdef.module-->]]>

<![ %glosssee.module; [
<!ENTITY % local.glosssee.attrib "">
<!ELEMENT GlossSee - O ((%para.char.mix;)+)>
<!ATTLIST GlossSee
		%common.attrib;

		--OtherTerm: link to GlossEntry of real term to look up--
		OtherTerm	IDREF		#CONREF
		%local.glosssee.attrib;
>
<!--end of glosssee.module-->]]>

<![ %glossseealso.module; [
<!ENTITY % local.glossseealso.attrib "">
<!ELEMENT GlossSeeAlso - O ((%para.char.mix;)+)>
<!ATTLIST GlossSeeAlso
		%common.attrib;

		--OtherTerm: link to GlossEntry of related term--
		OtherTerm	IDREF		#CONREF
		%local.glossseealso.attrib;
>
<!--end of glossseealso.module-->]]>
<!--end of glossentry.content.module-->]]>

<!-- ItemizedList and OrderedList ..... -->

<![ %itemizedlist.module; [
<!ENTITY % local.itemizedlist.attrib "">
<!ELEMENT ItemizedList - - (ListItem+)>
<!ATTLIST ItemizedList	
		%common.attrib;

		--Mark: keyword, e.g., bullet, dash, checkbox, none;
		list of keywords and defaults are implementation specific--
		%mark.attrib;
		%local.itemizedlist.attrib;
>
<!--end of itemizedlist.module-->]]>

<![ %orderedlist.module; [
<!ENTITY % local.orderedlist.attrib "">
<!ELEMENT OrderedList - - (ListItem+)>
<!ATTLIST OrderedList
		%common.attrib;

		--Numeration: style of list numbering; defaults are
		implementation specific--
		Numeration	(Arabic
				|Upperalpha
				|Loweralpha
				|Upperroman
				|Lowerroman)	#IMPLIED

		--InheritNum: builds lower-level numbers by prefixing
		higher-level item numbers (e.g., 1, 1a, 1b)--
		InheritNum	(Inherit
				|Ignore)	Ignore

		--Continuation: whether numbers are reset from previous list--
		Continuation	(Continues
				|Restarts)	Restarts
		%local.orderedlist.attrib;
>
<!--end of orderedlist.module-->]]>

<![ %listitem.module; [
<!ENTITY % local.listitem.attrib "">
<!ELEMENT ListItem - - ((%component.mix;)+)>
<!ATTLIST ListItem
		%common.attrib;

		--Override: character or string to replace default mark for
		this item only; default is implementation specific--
		Override	CDATA		#IMPLIED
		%local.listitem.attrib;
>
<!--end of listitem.module-->]]>

<!-- SegmentedList .................... -->

<![ %segmentedlist.content.module; [
<![ %segmentedlist.module; [
<!ENTITY % local.segmentedlist.attrib "">
<!ELEMENT SegmentedList - - ((%formalobject.title.content;)?, SegTitle*,
		SegListItem+)>
<!ATTLIST SegmentedList
		%common.attrib;
		%local.segmentedlist.attrib;
>
<!--end of segmentedlist.module-->]]>

<![ %segtitle.module; [
<!ENTITY % local.segtitle.attrib "">
<!ELEMENT SegTitle - - ((%inline.char.mix;)+)>
<!ATTLIST SegTitle
		%common.attrib;
		%local.segtitle.attrib;
>
<!--end of segtitle.module-->]]>

<![ %seglistitem.module; [
<!ENTITY % local.seglistitem.attrib "">
<!ELEMENT SegListItem - - (Seg, Seg+)>
<!ATTLIST SegListItem
		%common.attrib;
		%local.seglistitem.attrib;
>
<!--end of seglistitem.module-->]]>

<![ %seg.module; [
<!ENTITY % local.seg.attrib "">
<!ELEMENT Seg - - ((%inline.char.mix;)+)>
<!ATTLIST Seg
		%common.attrib;
		%local.seg.attrib;
>
<!--end of seg.module-->]]>
<!--end of segmentedlist.content.module-->]]>

<!-- SimpleList ....................... -->

<![ %simplelist.content.module; [
<![ %simplelist.module; [
<!ENTITY % local.simplelist.attrib "">
<!ELEMENT SimpleList - - (Member+)>
<!ATTLIST SimpleList
		%common.attrib;

		--Columns: number of columns--
		Columns		NUMBER		#IMPLIED

		--Type: Inline: members separated with commas etc. inline
			Vert: members top to bottom in n Columns
			Horiz: members left to right in n Columns
		If Column=1 or implied, Vert and Horiz are the same--
		Type		(Inline
				|Vert
				|Horiz)		Vert
		%local.simplelist.attrib;
>
<!--end of simplelist.module-->]]>

<![ %member.module; [
<!ENTITY % local.member.attrib "">
<!ELEMENT Member - - ((%inline.char.mix;)+)>
<!ATTLIST Member
		%common.attrib;
		%local.member.attrib;
>
<!--end of member.module-->]]>
<!--end of simplelist.content.module-->]]>

<!-- VariableList ..................... -->

<![ %variablelist.content.module; [
<![ %variablelist.module; [
<!ENTITY % local.variablelist.attrib "">
<!ELEMENT VariableList - - ((%formalobject.title.content;)?, VarListEntry+)>
<!ATTLIST VariableList
		%common.attrib;
		%local.variablelist.attrib;
>
<!--end of variablelist.module-->]]>

<![ %varlistentry.module; [
<!ENTITY % local.varlistentry.attrib "">
<!ELEMENT VarListEntry - - (Term+, ListItem)>
<!ATTLIST VarListEntry
		%common.attrib;
		%local.varlistentry.attrib;
>
<!--end of varlistentry.module-->]]>

<![ %term.module; [
<!ENTITY % local.term.attrib "">
<!ELEMENT Term - - ((%inline.char.mix;)+)>
<!ATTLIST Term
		%common.attrib;
		%local.term.attrib;
>
<!--end of term.module-->]]>

<!--ELEMENT ListItem (defined above)-->
<!--end of variablelist.content.module-->]]>

<!-- ...................................................................... -->
<!-- Objects .............................................................. -->

<!-- Examples etc. .................... -->

<![ %example.module; [
<!ENTITY % local.example.attrib "">
<!ELEMENT Example - - ((%formalobject.title.content;), (%example.mix;)+)>
<!ATTLIST Example
		%common.attrib;
		%label.attrib;
		%local.example.attrib;
>
<!--end of example.module-->]]>

<![ %informalexample.module; [
<!ENTITY % local.informalexample.attrib "">
<!ELEMENT InformalExample - - ((%example.mix;)+)>
<!ATTLIST InformalExample
		%common.attrib;
		%local.informalexample.attrib;
>
<!--end of informalexample.module-->]]>

<![ %programlisting.module; [
<!ENTITY % local.programlisting.attrib "">
<!ELEMENT ProgramListing - - ((%programlisting.content;)+)>
<!ATTLIST ProgramListing
		%common.attrib;
		%linespecific.attrib;

		--Width: number of columns in longest line, for management
		of wide output (e.g., 80)--
		Width		NUMBER		#IMPLIED
		%local.programlisting.attrib;
>
<!--end of programlisting.module-->]]>

<![ %literallayout.module; [
<!ENTITY % local.literallayout.attrib "">
<!ELEMENT LiteralLayout - - ((LineAnnotation | %inline.char.mix;)+)>
<!ATTLIST LiteralLayout
		%common.attrib;
		%linespecific.attrib;

		--Width: number of columns in longest line, for management
		of wide output (e.g., 80)--
		Width		NUMBER		#IMPLIED
		%local.literallayout.attrib;
>
<!--ELEMENT LineAnnotation (defined in the Inlines section, below)-->
<!--end of literallayout.module-->]]>

<![ %screen.module; [
<!ENTITY % local.screen.attrib "">
<!ELEMENT Screen - - ((%screen.content;)+)>
<!ATTLIST Screen
		%common.attrib;
		%linespecific.attrib;

		--Width: number of columns in longest line, for management
		of wide output (e.g., 80)--
		Width		NUMBER		#IMPLIED
		%local.screen.attrib;
>
<!--end of screen.module-->]]>

<![ %screenshot.content.module; [
<![ %screenshot.module; [
<!ENTITY % local.screenshot.attrib "">
<!ELEMENT ScreenShot - - (ScreenInfo?, Graphic)>
<!ATTLIST ScreenShot
		%common.attrib;
		%local.screenshot.attrib;
>
<!--end of screenshot.module-->]]>

<![ %screeninfo.module; [
<!ENTITY % local.screeninfo.attrib "">
<!ELEMENT ScreenInfo - - (#PCDATA) -(%ubiq.mix;)>
<!ATTLIST ScreenInfo
		%common.attrib;
		%local.screeninfo.attrib;
>
<!--end of screeninfo.module-->]]>
<!--end of screenshot.content.module-->]]>

<!-- Figures etc. ..................... -->

<![ %figure.module; [
<!ENTITY % local.figure.attrib "">
<!ELEMENT Figure - - ((%formalobject.title.content;), (%figure.mix; |
		%link.char.class;)+)>
<!ATTLIST Figure
		%common.attrib;

		--Float: whether figure can float in output--
		Float		%yesorno.attvals;	%no.attval;
		%label.attrib;
		%local.figure.attrib;
>
<!--end of figure.module-->]]>

<!-- Graphical data can be the content of Graphic, or you can reference
     an external file either as an entity (Entitref) or a filename
     (Fileref). -->

<![ %graphic.module; [
<!ENTITY % local.graphic.attrib "">
<!ELEMENT Graphic - - CDATA>
<!ATTLIST Graphic
		%common.attrib;
		%graphic.attrib;
		%local.graphic.attrib;
>
<!--end of graphic.module-->]]>

<![ %inlinegraphic.module; [
<!ENTITY % local.inlinegraphic.attrib "">
<!ELEMENT InlineGraphic - - CDATA>
<!ATTLIST InlineGraphic
		%common.attrib;
		%graphic.attrib;
		%local.inlinegraphic.attrib;
>
<!--end of inlinegraphic.module-->]]>

<!-- Equations ........................ -->

<![ %equation.module; [
<!ENTITY % local.equation.attrib "">
<!ELEMENT Equation - - ((%formalobject.title.content;)?, (InformalEquation |
		%equation.content;))>
<!ATTLIST Equation
	 	%common.attrib;
		%label.attrib;
		%local.equation.attrib;
>
<!--end of equation.module-->]]>

<![ %informalequation.module; [
<!ENTITY % local.informalequation.attrib "">
<!ELEMENT InformalEquation - - (%equation.content;)>
<!ATTLIST InformalEquation
		%common.attrib;
		%local.informalequation.attrib;
>
<!--end of informalequation.module-->]]>

<![ %inlineequation.module; [
<!ENTITY % local.inlineequation.attrib "">
<!ELEMENT InlineEquation - - (%inlineequation.content;)>
<!ATTLIST InlineEquation
		%common.attrib;
		%local.inlineequation.attrib;
>
<!--end of inlineequation.module-->]]>

<!-- Tables ........................... -->

<![ %table.module; [

<!ENTITY % bodyatt "%label.attrib;"	-- add Label to main element -->
<!ENTITY % secur   "%common.attrib;"	-- add common atts to all elements -->
<!ENTITY % tblelm "Table"		-- remove Chart -->
<!ENTITY % tblmdl  "((%formalobject.title.content;), (Graphic+|TGroup+))"
					-- content model for formal tables -->
<!ENTITY % tblexpt "-(Table|InformalTable)"
					-- exclude all DocBook tables -->
<!ENTITY % tblcon  "((%tabentry.mix;)+|(%para.char.mix;)+)"
					-- allow either blocks or inlines;
					   beware of REs between elems -->
<!ENTITY % tblrowex ""			-- remove pgbrk exception on row -->
<!ENTITY % tblconex ""			-- remove pgbrk exception on entry -->

<!ENTITY % calstbl PUBLIC
	"-//Davenport//ELEMENTS CALS-Based DocBook Table Model V2.3//EN">
%calstbl;

<!--end of table.module-->]]>

<![ %informaltable.module; [
<!ENTITY % local.informaltable.attrib "">
<!ELEMENT InformalTable - - (Graphic+|TGroup+) %tblexpt;>
<!ATTLIST InformalTable
		ToCEntry	%yesorno.attvals;	#IMPLIED
		ShortEntry	%yesorno.attvals;	#IMPLIED
		Frame		(Top
				|Bottom
				|Topbot
				|All
				|Sides
				|None)			#IMPLIED
		Colsep		%yesorno.attvals;	#IMPLIED
		Rowsep		%yesorno.attvals;	#IMPLIED
		%tblatt;	-- includes TabStyle, Orient, PgWide --
		%bodyatt;	-- includes Label --
		%secur;		-- includes common atts --
		%local.informaltable.attrib;
>
<!--end of informaltable.module-->]]>

<!-- ...................................................................... -->
<!-- Synopses ............................................................. -->

<!-- Synopsis ......................... -->

<![ %synopsis.module; [
<!ENTITY % local.synopsis.attrib "">
<!ELEMENT Synopsis - - ((LineAnnotation | %inline.char.mix; | Graphic)+)>
<!ATTLIST Synopsis
		%common.attrib;
		%linespecific.attrib;
		%label.attrib;
		%local.synopsis.attrib;
>

<!--ELEMENT LineAnnotation (defined in the Inlines section, below)-->
<!--end of synopsis.module-->]]>

<!-- CmdSynopsis ...................... -->

<![ %cmdsynopsis.content.module; [
<![ %cmdsynopsis.module; [
<!ENTITY % local.cmdsynopsis.attrib "">
<!ELEMENT CmdSynopsis - - ((Arg | Group)*, Command, (Arg | Group)*,
		SynopFragment*)>
<!ATTLIST CmdSynopsis
		%common.attrib;
		%label.attrib;

		--Sepchar: character that should separate command and
		all top-level arguments; alternate value might be &Delta;--
		Sepchar		CDATA		" "
		%local.cmdsynopsis.attrib;
>
<!--end of cmdsynopsis.module-->]]>

<![ %arg.module; [
<!ENTITY % local.arg.attrib "">
<!ELEMENT Arg - - ((#PCDATA | Arg | Group | Option | SynopFragmentRef |
		Replaceable)+)>
<!ATTLIST Arg
		%common.attrib;

		--Choice: whether Arg must be supplied:
			Opt: optional to supply (e.g. [arg])
			Req: required to supply (e.g. {arg})
			Plain: required to supply (e.g. arg)--
		Choice		(Opt
				|Req
				|Plain)		Opt

		--Rep: whether Arg is repeatable:
			Norepeat: no (e.g. arg without ellipsis)
			Repeat: yes (e.g. arg...)--
		Rep		(Norepeat
				|Repeat)	Norepeat
		%local.arg.attrib;
>
<!--end of arg.module-->]]>

<![ %group.module; [
<!ENTITY % local.group.attrib "">
<!ELEMENT Group - - ((Arg | Group | SynopFragmentRef | Replaceable)+)>
<!ATTLIST Group
		%common.attrib;

		--Choice: whether Group must be supplied:
			Opt: optional to supply (e.g. [g1|g2|g3])
			Req: required to supply (e.g. {g1|g2|g3})
			Plain: required to supply (e.g. g1|g2|g3)
			OptMult: can supply 0+ (e.g. [[g1|g2|g3]])
			ReqMult: must supply 1+ (e.g. {{g1|g2|g3}})--
		Choice		(Opt
				|Req
				|Plain
				|Optmult
				|Reqmult)	Opt

		--Rep: whether Group is repeatable:
			Norepeat: no (e.g. group without ellipsis)
			Repeat: yes (e.g. group...)--
		Rep		(Norepeat
				|Repeat)	Norepeat
		%local.group.attrib;
>
<!--end of group.module-->]]>

<![ %synopfragmentref.module; [
<!ENTITY % local.synopfragmentref.attrib "">
<!ELEMENT SynopFragmentRef - - RCDATA >
<!ATTLIST SynopFragmentRef
		%common.attrib;
		%linkendreq.attrib; --to SynopFragment of complex synopsis
		material for separate referencing--
		%local.synopfragmentref.attrib;
>
<!--end of synopfragmentref.module-->]]>

<![ %synopfragment.module; [
<!ENTITY % local.synopfragment.attrib "">
<!ELEMENT SynopFragment - - ((Arg | Group)+)>
<!ATTLIST SynopFragment
		%idreq.common.attrib;
		%local.synopfragment.attrib;
>
<!--end of synopfragment.module-->]]>

<!--ELEMENT Command (defined in the Inlines section, below)-->
<!--ELEMENT Option (defined in the Inlines section, below)-->
<!--ELEMENT Replaceable (defined in the Inlines section, below)-->
<!--end of cmdsynopsis.content.module-->]]>

<!-- FuncSynopsis ..................... -->

<![ %funcsynopsis.content.module; [
<![ %funcsynopsis.module; [
<!ENTITY % local.funcsynopsis.attrib "">
<!ELEMENT FuncSynopsis - - (FuncSynopsisInfo?, ((FuncDef, (Void | VarArgs |
		ParamDef+)))+ )>
<!ATTLIST FuncSynopsis
		%common.attrib;
		%label.attrib;
		%local.funcsynopsis.attrib;
>
<!--end of funcsynopsis.module-->]]>

<![ %funcsynopsisinfo.module; [
<!ENTITY % local.funcsynopsisinfo.attrib "">
<!ELEMENT FuncSynopsisInfo - - ((LineAnnotation | %cptr.char.mix;)* )>
<!ATTLIST FuncSynopsisInfo
		%common.attrib;
		%linespecific.attrib;
		%local.funcsynopsisinfo.attrib;
>
<!--end of funcsynopsisinfo.module-->]]>

<![ %funcdef.module; [
<!ENTITY % local.funcdef.attrib "">
<!ELEMENT FuncDef - - ((#PCDATA | Replaceable | Function)*)>
<!ATTLIST FuncDef
		%common.attrib;
		%local.funcdef.attrib;
>
<!--end of funcdef.module-->]]>

<![ %void.module; [
<!ENTITY % local.void.attrib "">
<!ELEMENT Void - O EMPTY>
<!ATTLIST Void
		%common.attrib;
		%local.void.attrib;
>
<!--end of void.module-->]]>

<![ %varargs.module; [
<!ENTITY % local.varargs.attrib "">
<!ELEMENT VarArgs - O EMPTY>
<!ATTLIST VarArgs
		%common.attrib;
		%local.varargs.attrib;
>
<!--end of varargs.module-->]]>

<!-- Processing assumes that only one Parameter will appear in a
     ParamDef, and that FuncParams will be used at most once, for
     providing information on the "inner parameters" for parameters that
     are pointers to functions. -->

<![ %paramdef.module; [
<!ENTITY % local.paramdef.attrib "">
<!ELEMENT ParamDef - - ((#PCDATA | Replaceable | Parameter | FuncParams)*)>
<!ATTLIST ParamDef
		%common.attrib;
		%local.paramdef.attrib;
>
<!--end of paramdef.module-->]]>

<![ %funcparams.module; [
<!ENTITY % local.funcparams.attrib "">
<!ELEMENT FuncParams - - ((%cptr.char.mix;)*)>
<!ATTLIST FuncParams
		%common.attrib;
		%local.funcparams.attrib;
>
<!--end of funcparams.module-->]]>

<!--ELEMENT LineAnnotation (defined in the Inlines section, below)-->
<!--ELEMENT Replaceable (defined in the Inlines section, below)-->
<!--ELEMENT Function (defined in the Inlines section, below)-->
<!--ELEMENT Parameter (defined in the Inlines section, below)-->
<!--end of funcsynopsis.content.module-->]]>

<!-- ...................................................................... -->
<!-- Document information entities and elements ........................... -->

<!ENTITY % local.person.ident.mix "">
<!ENTITY % person.ident.mix
		"Honorific|FirstName|Surname|Lineage|OtherName|Affiliation
		|AuthorBlurb|Contrib %local.person.ident.mix;">

<!-- The document information elements include some elements that are
     currently used only in the document hierarchy module. They are
     defined here so that they will be available for use in customized
     document hierarchies. -->

<!-- .................................. -->

<![ %docinfo.content.module; [

<!-- Ackno ............................ -->

<![ %ackno.module; [
<!ENTITY % local.ackno.attrib "">
<!ELEMENT Ackno - - (#PCDATA)>
<!ATTLIST Ackno
		%common.attrib;
		%local.ackno.attrib;
>
<!--end of ackno.module-->]]>

<!-- Address .......................... -->

<![ %address.content.module; [
<![ %address.module; [
<!ENTITY % local.address.attrib "">
<!ELEMENT Address - - (Street|POB|Postcode|City|State|Country|Phone|Fax
		|Email|OtherAddr)*>
<!ATTLIST Address
		%common.attrib;
		%local.address.attrib;
>
<!--end of address.module-->]]>

  <![ %street.module; [
  <!ENTITY % local.street.attrib "">
  <!ELEMENT Street - - (#PCDATA)>
  <!ATTLIST Street
		%common.attrib;
		%local.street.attrib;
>
  <!--end of street.module-->]]>

  <![ %pob.module; [
  <!ENTITY % local.pob.attrib "">
  <!ELEMENT POB - - (#PCDATA)>
  <!ATTLIST POB
		%common.attrib;
		%local.pob.attrib;
>
  <!--end of pob.module-->]]>

  <![ %postcode.module; [
  <!ENTITY % local.postcode.attrib "">
  <!ELEMENT Postcode - - (#PCDATA)>
  <!ATTLIST Postcode
		%common.attrib;
		%local.postcode.attrib;
>
  <!--end of postcode.module-->]]>

  <![ %city.module; [
  <!ENTITY % local.city.attrib "">
  <!ELEMENT City - - (#PCDATA)>
  <!ATTLIST City
		%common.attrib;
		%local.city.attrib;
>
  <!--end of city.module-->]]>

  <![ %state.module; [
  <!ENTITY % local.state.attrib "">
  <!ELEMENT State - - (#PCDATA)>
  <!ATTLIST State
		%common.attrib;
		%local.state.attrib;
>
  <!--end of state.module-->]]>

  <![ %country.module; [
  <!ENTITY % local.country.attrib "">
  <!ELEMENT Country - - (#PCDATA)>
  <!ATTLIST Country
		%common.attrib;
		%local.country.attrib;
>
  <!--end of country.module-->]]>

  <![ %phone.module; [
  <!ENTITY % local.phone.attrib "">
  <!ELEMENT Phone - - (#PCDATA)>
  <!ATTLIST Phone
		%common.attrib;
		%local.phone.attrib;
>
  <!--end of phone.module-->]]>

  <![ %fax.module; [
  <!ENTITY % local.fax.attrib "">
  <!ELEMENT Fax - - (#PCDATA)>
  <!ATTLIST Fax
		%common.attrib;
		%local.fax.attrib;
>
  <!--end of fax.module-->]]>

  <![ %email.module; [
  <!ENTITY % local.email.attrib "">
  <!ELEMENT Email - - (#PCDATA)>
  <!ATTLIST Email
		%common.attrib;
		%local.email.attrib;
>
  <!--end of email.module-->]]>

  <![ %otheraddr.module; [
  <!ENTITY % local.otheraddr.attrib "">
  <!ELEMENT OtherAddr - - (#PCDATA)>
  <!ATTLIST OtherAddr
		%common.attrib;
		%local.otheraddr.attrib;
>
  <!--end of otheraddr.module-->]]>
<!--end of address.content.module-->]]>

<!-- Affiliation ...................... -->

<![ %affiliation.content.module; [
<![ %affiliation.module; [
<!ENTITY % local.affiliation.attrib "">
<!ELEMENT Affiliation - - (ShortAffil?, JobTitle*, OrgName?, OrgDiv*,
		Address*)>
<!ATTLIST Affiliation
		%common.attrib;
		%local.affiliation.attrib;
>
<!--end of affiliation.module-->]]>

  <![ %shortaffil.module; [
  <!ENTITY % local.shortaffil.attrib "">
  <!ELEMENT ShortAffil - - (#PCDATA)>
  <!ATTLIST ShortAffil
		%common.attrib;
		%local.shortaffil.attrib;
>
  <!--end of shortaffil.module-->]]>

  <![ %jobtitle.module; [
  <!ENTITY % local.jobtitle.attrib "">
  <!ELEMENT JobTitle - - (#PCDATA)>
  <!ATTLIST JobTitle
		%common.attrib;
		%local.jobtitle.attrib;
>
  <!--end of jobtitle.module-->]]>

  <!--ELEMENT OrgName (defined elsewhere in this section)-->

  <![ %orgdiv.module; [
  <!ENTITY % local.orgdiv.attrib "">
  <!ELEMENT OrgDiv - - (#PCDATA)>
  <!ATTLIST OrgDiv
		%common.attrib;
		%local.orgdiv.attrib;
>
  <!--end of orgdiv.module-->]]>

  <!--ELEMENT Address (defined elsewhere in this section)-->
<!--end of affiliation.content.module-->]]>

<!-- ArtPageNums ...................... -->

<![ %artpagenums.module; [
<!ENTITY % local.artpagenums.attrib "">
<!ELEMENT ArtPageNums - - (#PCDATA)>
<!ATTLIST ArtPageNums
		%common.attrib;
		%local.artpagenums.attrib;
>
<!--end of artpagenums.module-->]]>

<!-- Author ........................... -->

<![ %author.module; [
<!ENTITY % local.author.attrib "">
<!ELEMENT Author - - ((%person.ident.mix;)+)>
<!ATTLIST Author
		%common.attrib;
		%local.author.attrib;
>
<!--(see "personal identity elements" for %person.ident.mix;)-->
<!--end of author.module-->]]>

<!-- AuthorGroup ...................... -->

<![ %authorgroup.content.module; [
<![ %authorgroup.module; [
<!ENTITY % local.authorgroup.attrib "">
<!ELEMENT AuthorGroup - - ((Author|Editor|Collab|CorpAuthor|OtherCredit)+)>
<!ATTLIST AuthorGroup
		%common.attrib;
		%local.authorgroup.attrib;
>
<!--end of authorgroup.module-->]]>

  <!--ELEMENT Author (defined elsewhere in this section)-->
  <!--ELEMENT Editor (defined elsewhere in this section)-->

  <![ %collab.content.module; [
  <![ %collab.module; [
  <!ENTITY % local.collab.attrib "">
  <!ELEMENT Collab - - (CollabName, Affiliation*)>
  <!ATTLIST Collab
		%common.attrib;
		%local.collab.attrib;
>
  <!--end of collab.module-->]]>

    <![ %collabname.module; [
  <!ENTITY % local.collabname.attrib "">
    <!ELEMENT CollabName - - (#PCDATA)>
    <!ATTLIST CollabName
		%common.attrib;
		%local.collabname.attrib;
>
    <!--end of collabname.module-->]]>

    <!--ELEMENT Affiliation (defined elsewhere in this section)-->
  <!--end of collab.content.module-->]]>

  <!--ELEMENT CorpAuthor (defined elsewhere in this section)-->
  <!--ELEMENT OtherCredit (defined elsewhere in this section)-->

<!--end of authorgroup.content.module-->]]>

<!-- AuthorInitials ................... -->

<![ %authorinitials.module; [
<!ENTITY % local.authorinitials.attrib "">
<!ELEMENT AuthorInitials - - (#PCDATA)>
<!ATTLIST AuthorInitials
		%common.attrib;
		%local.authorinitials.attrib;
>
<!--end of authorinitials.module-->]]>

<!-- ConfGroup ........................ -->

<![ %confgroup.content.module; [
<![ %confgroup.module; [
<!ENTITY % local.confgroup.attrib "">
<!ELEMENT ConfGroup - - ((ConfDates|ConfTitle|ConfNum|Address|ConfSponsor)*)>
<!ATTLIST ConfGroup
		%common.attrib;
		%local.confgroup.attrib;
>
<!--end of confgroup.module-->]]>

  <![ %confdates.module; [
  <!ENTITY % local.confdates.attrib "">
  <!ELEMENT ConfDates - - (#PCDATA)>
  <!ATTLIST ConfDates
		%common.attrib;
		%local.confdates.attrib;
>
  <!--end of confdates.module-->]]>

  <![ %conftitle.module; [
  <!ENTITY % local.conftitle.attrib "">
  <!ELEMENT ConfTitle - - (#PCDATA)>
  <!ATTLIST ConfTitle
		%common.attrib;
		%local.conftitle.attrib;
>
  <!--end of conftitle.module-->]]>

  <![ %confnum.module; [
  <!ENTITY % local.confnum.attrib "">
  <!ELEMENT ConfNum - - (#PCDATA)>
  <!ATTLIST ConfNum
		%common.attrib;
		%local.confnum.attrib;
>
  <!--end of confnum.module-->]]>

  <!--ELEMENT Address (defined elsewhere in this section)-->

  <![ %confsponsor.module; [
  <!ENTITY % local.confsponsor.attrib "">
  <!ELEMENT ConfSponsor - - (#PCDATA)>
  <!ATTLIST ConfSponsor
		%common.attrib;
		%local.confsponsor.attrib;
>
  <!--end of confsponsor.module-->]]>
<!--end of confgroup.content.module-->]]>

<!-- ContractNum ...................... -->

<![ %contractnum.module; [
<!ENTITY % local.contractnum.attrib "">
<!ELEMENT ContractNum - - (#PCDATA)>
<!ATTLIST ContractNum
		%common.attrib;
		%local.contractnum.attrib;
>
<!--end of contractnum.module-->]]>

<!-- ContractSponsor .................. -->

<![ %contractsponsor.module; [
<!ENTITY % local.contractsponsor.attrib "">
<!ELEMENT ContractSponsor - - (#PCDATA)>
<!ATTLIST ContractSponsor
		%common.attrib;
		%local.contractsponsor.attrib;
>
<!--end of contractsponsor.module-->]]>

<!-- Copyright ........................ -->

<![ %copyright.content.module; [
<![ %copyright.module; [
<!ENTITY % local.copyright.attrib "">
<!ELEMENT Copyright - - (Year+, Holder*)>
<!ATTLIST Copyright
		%common.attrib;
		%local.copyright.attrib;
>
<!--end of copyright.module-->]]>

  <![ %year.module; [
  <!ENTITY % local.year.attrib "">
  <!ELEMENT Year - - (#PCDATA)>
  <!ATTLIST Year
		%common.attrib;
		%local.year.attrib;
>
  <!--end of year.module-->]]>

  <![ %holder.module; [
  <!ENTITY % local.holder.attrib "">
  <!ELEMENT Holder - - (#PCDATA)>
  <!ATTLIST Holder
		%common.attrib;
		%local.holder.attrib;
>
  <!--end of holder.module-->]]>
<!--end of copyright.content.module-->]]>

<!-- CorpAuthor ....................... -->

<![ %corpauthor.module; [
<!ENTITY % local.corpauthor.attrib "">
<!ELEMENT CorpAuthor - - (#PCDATA)>
<!ATTLIST CorpAuthor
		%common.attrib;
		%local.corpauthor.attrib;
>
<!--end of corpauthor.module-->]]>

<!-- CorpName ......................... -->

<![ %corpname.module; [
<!ENTITY % local.corpname.attrib "">
<!ELEMENT CorpName - - (#PCDATA)>
<!ATTLIST CorpName
		%common.attrib;
		%local.corpname.attrib;
>
<!--end of corpname.module-->]]>

<!-- Date ............................. -->

<![ %date.module; [
<!ENTITY % local.date.attrib "">
<!ELEMENT Date - - (#PCDATA)>
<!ATTLIST Date
		%common.attrib;
		%local.date.attrib;
>
<!--end of date.module-->]]>

<!-- Edition .......................... -->

<![ %edition.module; [
<!ENTITY % local.edition.attrib "">
<!ELEMENT Edition - - (#PCDATA)>
<!ATTLIST Edition
		%common.attrib;
		%local.edition.attrib;
>
<!--end of edition.module-->]]>

<!-- Editor ........................... -->

<![ %editor.module; [
<!ENTITY % local.editor.attrib "">
<!ELEMENT Editor - - ((%person.ident.mix;)+)>
<!ATTLIST Editor
		%common.attrib;
		%local.editor.attrib;
>
  <!--(see "personal identity elements" for %person.ident.mix;)-->
<!--end of editor.module-->]]>

<!-- ISBN ............................. -->

<![ %isbn.module; [
<!ENTITY % local.isbn.attrib "">
<!ELEMENT ISBN - - (#PCDATA)>
<!ATTLIST ISBN
		%common.attrib;
		%local.isbn.attrib;
>
<!--end of isbn.module-->]]>

<!-- ISSN ............................. -->

<![ %issn.module; [
<!ENTITY % local.issn.attrib "">
<!ELEMENT ISSN - - (#PCDATA)>
<!ATTLIST ISSN
		%common.attrib;
		%local.issn.attrib;
>
<!--end of issn.module-->]]>

<!-- InvPartNumber .................... -->

<![ %invpartnumber.module; [
<!ENTITY % local.invpartnumber.attrib "">
<!ELEMENT InvPartNumber - - (#PCDATA)>
<!ATTLIST InvPartNumber
		%common.attrib;
		%local.invpartnumber.attrib;
>
<!--end of invpartnumber.module-->]]>

<!-- IssueNum ......................... -->

<![ %issuenum.module; [
<!ENTITY % local.issuenum.attrib "">
<!ELEMENT IssueNum - - (#PCDATA)>
<!ATTLIST IssueNum
		%common.attrib;
		%local.issuenum.attrib;
>
<!--end of issuenum.module-->]]>

<!-- LegalNotice ...................... -->

<![ %legalnotice.module; [
<!ENTITY % local.legalnotice.attrib "">
<!ELEMENT LegalNotice - - (Title?, (%legalnotice.mix;)+)>
<!ATTLIST LegalNotice
		%common.attrib;
		%local.legalnotice.attrib;
>
<!--end of legalnotice.module-->]]>

<!-- ModeSpec ......................... -->

<![ %modespec.module; [
<!ENTITY % local.modespec.attrib "">
<!ELEMENT ModeSpec - - (#PCDATA) -(%ubiq.mix;)>
<!ATTLIST ModeSpec
		%common.attrib;

		--Application: type of retrieval query--
		Application	NOTATION
				(%notation.class;)	#IMPLIED
		%local.modespec.attrib;
>
<!--end of modespec.module-->]]>

<!-- OrgName .......................... -->

<![ %orgname.module; [
<!ENTITY % local.orgname.attrib "">
<!ELEMENT OrgName - - (#PCDATA)>
<!ATTLIST OrgName
		%common.attrib;
		%local.orgname.attrib;
>
<!--end of orgname.module-->]]>

<!-- OtherCredit ...................... -->

<![ %othercredit.module; [
<!ENTITY % local.othercredit.attrib "">
<!ELEMENT OtherCredit - - ((%person.ident.mix;)+)>
<!ATTLIST OtherCredit
		%common.attrib;
		%local.othercredit.attrib;
>
  <!--(see "personal identity elements" for %person.ident.mix;)-->
<!--end of othercredit.module-->]]>

<!-- PageNums ......................... -->

<![ %pagenums.module; [
<!ENTITY % local.pagenums.attrib "">
<!ELEMENT PageNums - - (#PCDATA)>
<!ATTLIST PageNums
		%common.attrib;
		%local.pagenums.attrib;
>
<!--end of pagenums.module-->]]>

<!-- personal identity elements ....... -->

<!-- These elements are used only within Author, Editor, and OtherCredit. -->

<![ %person.ident.module; [
  <![ %contrib.module; [
  <!ENTITY % local.contrib.attrib "">
  <!ELEMENT Contrib - - (#PCDATA)>
  <!ATTLIST Contrib
		%common.attrib;
		%local.contrib.attrib;
>
  <!--end of contrib.module-->]]>

  <![ %firstname.module; [
  <!ENTITY % local.firstname.attrib "">
  <!ELEMENT FirstName - - (#PCDATA)>
  <!ATTLIST FirstName
		%common.attrib;
		%local.firstname.attrib;
>
  <!--end of firstname.module-->]]>

  <![ %honorific.module; [
  <!ENTITY % local.honorific.attrib "">
  <!ELEMENT Honorific - - (#PCDATA)>
  <!ATTLIST Honorific
		%common.attrib;
		%local.honorific.attrib;
>
  <!--end of honorific.module-->]]>

  <![ %lineage.module; [
  <!ENTITY % local.lineage.attrib "">
  <!ELEMENT Lineage - - (#PCDATA)>
  <!ATTLIST Lineage
		%common.attrib;
		%local.lineage.attrib;
>
  <!--end of lineage.module-->]]>

  <![ %othername.module; [
  <!ENTITY % local.othername.attrib "">
  <!ELEMENT OtherName - - (#PCDATA)>
  <!ATTLIST OtherName
		%common.attrib;
		%local.othername.attrib;
>
  <!--end of othername.module-->]]>

  <![ %surname.module; [
  <!ENTITY % local.surname.attrib "">
  <!ELEMENT Surname - - (#PCDATA)>
  <!ATTLIST Surname
		%common.attrib;
		%local.surname.attrib;
>
  <!--end of surname.module-->]]>
<!--end of person.ident.module-->]]>

<!-- PrintHistory ..................... -->

<![ %printhistory.module; [
<!ENTITY % local.printhistory.attrib "">
<!ELEMENT PrintHistory - - ((%para.class;)+)>
<!ATTLIST PrintHistory
		%common.attrib;
		%local.printhistory.attrib;
>
<!--end of printhistory.module-->]]>

<!-- ProductName ...................... -->

<![ %productname.module; [
<!ENTITY % local.productname.attrib "">
<!ELEMENT ProductName - - ((%inline.char.mix;)+)>
<!ATTLIST ProductName
		%common.attrib;
		Class		(Service
				|Trade
				|Registered
				|Copyright)	Trade
		%local.productname.attrib;
>
<!--end of productname.module-->]]>

<!-- ProductNumber .................... -->

<![ %productnumber.module; [
<!ENTITY % local.productnumber.attrib "">
<!ELEMENT ProductNumber - - (#PCDATA)>
<!ATTLIST ProductNumber
		%common.attrib;
		%local.productnumber.attrib;
>
<!--end of productnumber.module-->]]>

<!-- PubDate .......................... -->

<![ %pubdate.module; [
<!ENTITY % local.pubdate.attrib "">
<!ELEMENT PubDate - - (#PCDATA)>
<!ATTLIST PubDate
		%common.attrib;
		%local.pubdate.attrib;
>
<!--end of pubdate.module-->]]>

<!-- Publisher ........................ -->

<![ %publisher.content.module; [
<![ %publisher.module; [
<!ENTITY % local.publisher.attrib "">
<!ELEMENT Publisher - - (PublisherName, Address*)>
<!ATTLIST Publisher
		%common.attrib;
		%local.publisher.attrib;
>
<!--end of publisher.module-->]]>

  <![ %publishername.module; [
  <!ENTITY % local.publishername.attrib "">
  <!ELEMENT PublisherName - - (#PCDATA)>
  <!ATTLIST PublisherName
		%common.attrib;
		%local.publishername.attrib;
>
  <!--end of publishername.module-->]]>

  <!--ELEMENT Address (defined elsewhere in this section)-->
<!--end of publisher.content.module-->]]>

<!-- PubsNumber ....................... -->

<![ %pubsnumber.module; [
<!ENTITY % local.pubsnumber.attrib "">
<!ELEMENT PubsNumber - - (#PCDATA)>
<!ATTLIST PubsNumber
		%common.attrib;
		%local.pubsnumber.attrib;
>
<!--end of pubsnumber.module-->]]>

<!-- ReleaseInfo ...................... -->

<![ %releaseinfo.module; [
<!ENTITY % local.releaseinfo.attrib "">
<!ELEMENT ReleaseInfo - - (#PCDATA)>
<!ATTLIST ReleaseInfo
		%common.attrib;
		%local.releaseinfo.attrib;
>
<!--end of releaseinfo.module-->]]>

<!-- RevHistory ....................... -->

<![ %revhistory.content.module; [
<![ %revhistory.module; [
<!--FUTURE USE (V3.0):
<!ELEMENT RevHistory - - (Revision+)>
-->
<!ENTITY % local.revhistory.attrib "">
<!ELEMENT RevHistory - - (Revision*)>
<!ATTLIST RevHistory
		%common.attrib;
		%local.revhistory.attrib;
>
<!--end of revhistory.module-->]]>

  <![ %revision.module; [
  <!ENTITY % local.revision.attrib "">
  <!ELEMENT Revision - - (RevNumber, Date, AuthorInitials*, RevRemark?)>
  <!ATTLIST Revision
		%common.attrib;
		%local.revision.attrib;
>
  <!--end of revision.module-->]]>

  <![ %revnumber.module; [
  <!ENTITY % local.revnumber.attrib "">
  <!ELEMENT RevNumber - - (#PCDATA)>
  <!ATTLIST RevNumber
		%common.attrib;
		%local.revnumber.attrib;
>
  <!--end of revnumber.module-->]]>

  <!--ELEMENT Date (defined elsewhere in this section)-->
  <!--ELEMENT AuthorInitials (defined elsewhere in this section)-->

  <![ %revremark.module; [
  <!ENTITY % local.revremark.attrib "">
  <!ELEMENT RevRemark - - (#PCDATA)>
  <!ATTLIST RevRemark
		%common.attrib;
		%local.revremark.attrib;
>
  <!--end of revremark.module-->]]>
<!--end of revhistory.content.module-->]]>

<!-- SeriesVolNums .................... -->

<![ %seriesvolnums.module; [
<!ENTITY % local.seriesvolnums.attrib "">
<!ELEMENT SeriesVolNums - - (#PCDATA)>
<!ATTLIST SeriesVolNums
		%common.attrib;
		%local.seriesvolnums.attrib;
>
<!--end of seriesvolnums.module-->]]>

<!-- VolumeNum ........................ -->

<![ %volumenum.module; [
<!ENTITY % local.volumenum.attrib "">
<!ELEMENT VolumeNum - - (#PCDATA)>
<!ATTLIST VolumeNum
		%common.attrib;
		%local.volumenum.attrib;
>
<!--end of volumenum.module-->]]>

<!-- .................................. -->

<!--end of docinfo.content.module-->]]>

<!-- ...................................................................... -->
<!-- Inline, link, and ubiquitous elements ................................ -->

<!-- Computer terms ....................................................... -->

<![ %action.module; [
<!ENTITY % local.action.attrib "">
<!ELEMENT Action - - ((%cptr.char.mix;)+)>
<!ATTLIST Action
		%common.attrib;
		%moreinfo.attrib;
		%local.action.attrib;
>
<!--end of action.module-->]]>

<![ %application.module; [
<!ENTITY % local.application.attrib "">
<!ELEMENT Application - - ((%inline.char.mix;)+)>
<!ATTLIST Application
		%common.attrib;
		Class 		(Hardware
				|Software)	#IMPLIED
		%moreinfo.attrib;
		%local.application.attrib;
>
<!--end of application.module-->]]>

<![ %classname.module; [
<!ENTITY % local.classname.attrib "">
<!ELEMENT ClassName - - (#PCDATA)>
<!ATTLIST ClassName
		%common.attrib;
		%local.classname.attrib;
>
<!--end of classname.module-->]]>

<![ %command.module; [
<!ENTITY % local.command.attrib "">
<!ELEMENT Command - - ((%cptr.char.mix;)+)>
<!ATTLIST Command
		%common.attrib;
		%moreinfo.attrib;
		%local.command.attrib;
>
<!--end of command.module-->]]>

<![ %computeroutput.module; [
<!ENTITY % local.computeroutput.attrib "">
<!ELEMENT ComputerOutput - - ((%cptr.char.mix;)+)>
<!ATTLIST ComputerOutput
		%common.attrib;
		%moreinfo.attrib;
		%local.computeroutput.attrib;
>
<!--end of computeroutput.module-->]]>

<![ %database.module; [
<!ENTITY % local.database.attrib "">
<!ELEMENT Database - - ((%cptr.char.mix;)+)>
<!ATTLIST Database
		%common.attrib;
		Class 		(Name
				|Table
				|Field
				|Key1
				|Key2
				|Record)	#IMPLIED
		%moreinfo.attrib;
		%local.database.attrib;
>
<!--end of database.module-->]]>

<![ %errorname.module; [
<!ENTITY % local.errorname.attrib "">
<!ELEMENT ErrorName - - (#PCDATA)>
<!ATTLIST ErrorName
		%common.attrib;
		%local.errorname.attrib;
>
<!--end of errorname.module-->]]>

<![ %errortype.module; [
<!ENTITY % local.errortype.attrib "">
<!ELEMENT ErrorType - - (#PCDATA)>
<!ATTLIST ErrorType
		%common.attrib;
		%local.errortype.attrib;
>
<!--end of errortype.module-->]]>

<![ %filename.module; [
<!ENTITY % local.filename.attrib "">
<!ELEMENT Filename - - ((%cptr.char.mix;)+)>
<!ATTLIST Filename
		%common.attrib;
		%moreinfo.attrib;
		%local.filename.attrib;
>
<!--end of filename.module-->]]>

<![ %function.module; [
<!ENTITY % local.function.attrib "">
<!ELEMENT Function - - ((%cptr.char.mix;)+)>
<!ATTLIST Function
		%common.attrib;
		%moreinfo.attrib;
		%local.function.attrib;
>
<!--end of function.module-->]]>

<![ %hardware.module; [
<!ENTITY % local.hardware.attrib "">
<!ELEMENT Hardware - - ((%cptr.char.mix;)+)>
<!ATTLIST Hardware
		%common.attrib;
		%moreinfo.attrib;
		%local.hardware.attrib;
>
<!--end of hardware.module-->]]>

<![ %interface.module; [
<!ENTITY % local.interface.attrib "">
<!ELEMENT Interface - - ((%cptr.char.mix;)+)>
<!ATTLIST Interface
		%common.attrib;
		Class 		(Button
				|Icon
				|Menu
				|MenuItem)	#IMPLIED
		%moreinfo.attrib;
		%local.interface.attrib;
>
<!--end of interface.module-->]]>

<![ %interfacedefinition.module; [
<!ENTITY % local.interfacedefinition.attrib "">
<!ELEMENT InterfaceDefinition - - ((%cptr.char.mix;)+)>
<!ATTLIST InterfaceDefinition
		%common.attrib;
		%moreinfo.attrib;
		%local.interfacedefinition.attrib;
>
<!--end of interfacedefinition.module-->]]>

<![ %keycap.module; [
<!ENTITY % local.keycap.attrib "">
<!ELEMENT KeyCap - - ((%cptr.char.mix;)+)>
<!ATTLIST KeyCap
		%common.attrib;
		%moreinfo.attrib;
		%local.keycap.attrib;
>
<!--end of keycap.module-->]]>

<![ %keycode.module; [
<!ENTITY % local.keycode.attrib "">
<!ELEMENT KeyCode - - (#PCDATA)>
<!ATTLIST KeyCode
		%common.attrib;
		%local.keycode.attrib;
>
<!--end of keycode.module-->]]>

<![ %keysym.module; [
<!ENTITY % local.keysym.attrib "">
<!ELEMENT KeySym - - (#PCDATA)>
<!ATTLIST KeySym
		%common.attrib;
		%local.keysym.attrib;
>
<!--end of keysym.module-->]]>

<![ %literal.module; [
<!ENTITY % local.literal.attrib "">
<!ELEMENT Literal - - ((%cptr.char.mix;)+)>
<!ATTLIST Literal
		%common.attrib;
		%moreinfo.attrib;
		%local.literal.attrib;
>
<!--end of literal.module-->]]>

<![ %medialabel.module; [
<!ENTITY % local.medialabel.attrib "">
<!ELEMENT MediaLabel - - (#PCDATA)>
<!ATTLIST MediaLabel
		%common.attrib;
		Class 		(Cartridge
				|CDRom
				|Disk
				|Tape)		#IMPLIED
		%local.medialabel.attrib;
>
<!--end of medialabel.module-->]]>

<![ %msgtext.module; [
<!ENTITY % local.msgtext.attrib "">
<!ELEMENT MsgText - - ((%component.mix;)+)>
<!ATTLIST MsgText
		%common.attrib;
		%local.msgtext.attrib;
>
<!--end of msgtext.module-->]]>

<![ %option.module; [
<!ENTITY % local.option.attrib "">
<!ELEMENT Option - - ((%cptr.char.mix;)+)>
<!ATTLIST Option
		%common.attrib;
		%local.option.attrib;
>
<!--end of option.module-->]]>

<![ %optional.module; [
<!ENTITY % local.optional.attrib "">
<!ELEMENT Optional - - ((%cptr.char.mix;)+)>
<!ATTLIST Optional
		%common.attrib;
		%local.optional.attrib;
>
<!--end of optional.module-->]]>

<![ %parameter.module; [
<!ENTITY % local.parameter.attrib "">
<!ELEMENT Parameter - - ((%cptr.char.mix;)+)>
<!ATTLIST Parameter
		%common.attrib;
		Class 		(Command
				|Function
				|Option)	#IMPLIED
		%moreinfo.attrib;
		%local.parameter.attrib;
>
<!--end of parameter.module-->]]>

<![ %property.module; [
<!ENTITY % local.property.attrib "">
<!ELEMENT Property - - ((%cptr.char.mix;)+)>
<!ATTLIST Property
		%common.attrib;
		%moreinfo.attrib;
		%local.property.attrib;
>
<!--end of property.module-->]]>

<![ %replaceable.module; [
<!ENTITY % local.replaceable.attrib "">
<!ELEMENT Replaceable - - ((%phrase.char.mix;)+)>
<!ATTLIST Replaceable
		%common.attrib;
		Class		(Command
				|Function
				|Option
				|Parameter)	#IMPLIED
		%local.replaceable.attrib;
>
<!--end of replaceable.module-->]]>

<![ %returnvalue.module; [
<!ENTITY % local.returnvalue.attrib "">
<!ELEMENT ReturnValue - - (#PCDATA)>
<!ATTLIST ReturnValue
		%common.attrib;
		%local.returnvalue.attrib;
>
<!--end of returnvalue.module-->]]>

<![ %structfield.module; [
<!ENTITY % local.structfield.attrib "">
<!ELEMENT StructField - - (#PCDATA)>
<!ATTLIST StructField
		%common.attrib;
		%local.structfield.attrib;
>
<!--end of structfield.module-->]]>

<![ %structname.module; [
<!ENTITY % local.structname.attrib "">
<!ELEMENT StructName - - (#PCDATA)>
<!ATTLIST StructName
		%common.attrib;
		%local.structname.attrib;
>
<!--end of structname.module-->]]>

<![ %symbol.module; [
<!ENTITY % local.symbol.attrib "">
<!ELEMENT Symbol - - (#PCDATA)>
<!ATTLIST Symbol
		%common.attrib;
		%local.symbol.attrib;
>
<!--end of symbol.module-->]]>

<![ %systemitem.module; [
<!ENTITY % local.systemitem.attrib "">
<!ELEMENT SystemItem - - ((%cptr.char.mix;)+)>
<!ATTLIST SystemItem
		%common.attrib;
		Class		(Constant
				|EnvironVar
				|Macro
				|OSname
				|Prompt
				|Resource
				|SystemName)	#IMPLIED
		%moreinfo.attrib;
		%local.systemitem.attrib;
>
<!--end of systemitem.module-->]]>


<![ %token.module; [
<!ENTITY % local.token.attrib "">
<!ELEMENT Token - - (#PCDATA)>
<!ATTLIST Token
		%common.attrib;
		%local.token.attrib;
>
<!--end of token.module-->]]>

<![ %type.module; [
<!ENTITY % local.type.attrib "">
<!ELEMENT Type - - (#PCDATA)>
<!ATTLIST Type
		%common.attrib;
		%local.type.attrib;
>
<!--end of type.module-->]]>

<![ %userinput.module; [
<!ENTITY % local.userinput.attrib "">
<!ELEMENT UserInput - - ((%cptr.char.mix;)+)>
<!ATTLIST UserInput
		%common.attrib;
		%moreinfo.attrib;
		%local.userinput.attrib;
>
<!--end of userinput.module-->]]>

<!-- Words ................................................................ -->

<![ %abbrev.module; [
<!ENTITY % local.abbrev.attrib "">
<!ELEMENT Abbrev - - (#PCDATA)>
<!ATTLIST Abbrev
		%common.attrib;
		%local.abbrev.attrib;
>
<!--end of abbrev.module-->]]>

<![ %acronym.module; [
<!ENTITY % local.acronym.attrib "">
<!ELEMENT Acronym - - (#PCDATA)>
<!ATTLIST Acronym
		%common.attrib;
		%local.acronym.attrib;
>
<!--end of acronym.module-->]]>

<![ %citation.module; [
<!ENTITY % local.citation.attrib "">
<!ELEMENT Citation - - (#PCDATA)>
<!ATTLIST Citation
		%common.attrib;
		%local.citation.attrib;
>
<!--end of citation.module-->]]>

<![ %citerefentry.content.module; [
<![ %citerefentry.module; [
<!ENTITY % local.citerefentry.attrib "">
<!ELEMENT CiteRefEntry - - (RefEntryTitle, ManVolNum?)>
<!ATTLIST CiteRefEntry
		%common.attrib;
		%local.citerefentry.attrib;
>
<!--end of citerefentry.module-->]]>

  <![ %refentrytitle.module; [
  <!ENTITY % local.refentrytitle.attrib "">
  <!ELEMENT RefEntryTitle - - ((%inline.char.mix;)+)>
  <!ATTLIST RefEntryTitle
		%common.attrib;
		%local.refentrytitle.attrib;
>
  <!--end of refentrytitle.module-->]]>

  <![ %manvolnum.module; [
  <!ENTITY % local.manvolnum.attrib "">
  <!ELEMENT ManVolNum - - (#PCDATA)>
  <!ATTLIST ManVolNum
		%common.attrib;
		%local.manvolnum.attrib;
>
  <!--end of manvolnum.module-->]]>
<!--end of citerefentry.content.module-->]]>

<![ %citetitle.module; [
<!ENTITY % local.citetitle.attrib "">
<!ELEMENT CiteTitle - - ((%inline.char.mix;)+)>
<!ATTLIST CiteTitle
		%common.attrib;

		--Pubwork: type of published work being cited--
		Pubwork		(Article
				|Book
				|Chapter
				|Part
				|RefEntry
				|Section)	#IMPLIED
		%local.citetitle.attrib;
>
<!--end of citetitle.module-->]]>

<![ %emphasis.module; [
<!ENTITY % local.emphasis.attrib "">
<!ELEMENT Emphasis - - (#PCDATA)>
<!ATTLIST Emphasis
		%common.attrib;
		%local.emphasis.attrib;
>
<!--end of emphasis.module-->]]>

<![ %firstterm.module; [
<!ENTITY % local.firstterm.attrib "">
<!ELEMENT FirstTerm - - (#PCDATA)>
<!ATTLIST FirstTerm
		%common.attrib;
		%local.firstterm.attrib;
>
<!--end of firstterm.module-->]]>

<![ %foreignphrase.module; [
<!ENTITY % local.foreignphrase.attrib "">
<!ELEMENT ForeignPhrase - - (#PCDATA)>
<!ATTLIST ForeignPhrase
		%common.attrib;
		%local.foreignphrase.attrib;
>
<!--end of foreignphrase.module-->]]>

<![ %glossterm.module; [
<!ENTITY % local.glossterm.attrib "">
<!ELEMENT GlossTerm - - ((%para.char.mix;)+)>
<!ATTLIST GlossTerm
		%common.attrib;
		%local.glossterm.attrib;
>
<!--end of glossterm.module-->]]>

<![ %lineannotation.module; [
<!ENTITY % local.lineannotation.attrib "">
<!ELEMENT LineAnnotation - - (#PCDATA)>
<!ATTLIST LineAnnotation
		%common.attrib;
		%local.lineannotation.attrib;
>
<!--end of lineannotation.module-->]]>

<![ %markup.module; [
<!ENTITY % local.markup.attrib "">
<!ELEMENT Markup - - (#PCDATA)>
<!ATTLIST Markup
		%common.attrib;
		%local.markup.attrib;
>
<!--end of markup.module-->]]>

<![ %quote.module; [
<!ENTITY % local.quote.attrib "">
<!ELEMENT Quote - - ((%inline.char.mix;)+)>
<!ATTLIST Quote
		%common.attrib;
		%local.quote.attrib;
>
<!--end of quote.module-->]]>

<![ %sgmltag.module; [
<!ENTITY % local.sgmltag.attrib "">
<!ELEMENT SGMLTag - - (#PCDATA)>
<!ATTLIST SGMLTag
		%common.attrib;
		Class 		(Attribute
				|Element
				|GenEntity
				|ParamEntity)	#IMPLIED
		%local.sgmltag.attrib;
>
<!--end of sgmltag.module-->]]>

<![ %ssscript.module; [
<!ENTITY % local.ssscript.attrib "">
<!ELEMENT (Subscript | Superscript) - - ((%ssscript.char.mix;)+)
		-(%ubiq.mix;)>
<!ATTLIST (Subscript | Superscript)
		%common.attrib;
		%local.ssscript.attrib;
>
<!--end of ssscript.module-->]]>

<![ %trademark.module; [
<!ENTITY % local.trademark.attrib "">
<!ELEMENT Trademark - - ((%cptr.char.mix;)+)>
<!ATTLIST Trademark
		%common.attrib;
		Class		(Service
				|Trade
				|Registered
				|Copyright)	Trade
		%local.trademark.attrib;
>
<!--end of trademark.module-->]]>

<![ %wordasword.module; [
<!ENTITY % local.wordasword.attrib "">
<!ELEMENT WordAsWord - - (#PCDATA)>
<!ATTLIST WordAsWord
		%common.attrib;
		%local.wordasword.attrib;
>
<!--end of wordasword.module-->]]>

<!-- Links and cross-references ........................................... -->

<![ %link.module; [
<!ENTITY % local.link.attrib "">
<!ELEMENT Link - - ((%para.char.mix;)+)>
<!ATTLIST Link
		%common.attrib;

                --Endterm: pointer to description of linked-to object--
                Endterm		IDREF		#IMPLIED

		%linkendreq.attrib; --to linked-to object--

                --Type: user-defined role of link--
                Type            CDATA           #IMPLIED
		%local.link.attrib;
>
<!--end of link.module-->]]>

<![ %olink.module; [
<!ENTITY % local.olink.attrib "">
<!ELEMENT OLink - - ((%para.char.mix;)+)>
<!ATTLIST OLink
		%common.attrib;

                --TargetDocEnt: HyTimeish Docorsub pointer--
		TargetDocEnt	ENTITY 		#IMPLIED

                --LinkMode: points to a ModeSpec containing app-specific info--
		LinkMode	IDREF		#IMPLIED
		LocalInfo 	CDATA		#IMPLIED

                --Type: user-defined role of link--
		Type		CDATA		#IMPLIED
		%local.olink.attrib;
>
<!--end of olink.module-->]]>

<![ %ulink.module; [
<!ENTITY % local.ulink.attrib "">
<!ELEMENT ULink - - ((%para.char.mix;)+)>
<!ATTLIST ULink
		%common.attrib;

                --URL: uniform resource locator--
                URL		CDATA           #REQUIRED

                --Type: user-defined role of link--
                Type            CDATA           #IMPLIED
		%local.ulink.attrib;
>
<!--end of ulink.module-->]]>

<![ %footnoteref.module; [
<!--FUTURE USE (V3.0):
<!ELEMENT FootnoteRef - O EMPTY>
-->
<!ENTITY % local.footnoteref.attrib "">
<!ELEMENT FootnoteRef - - (#PCDATA) -(%ubiq.mix;)>
<!ATTLIST FootnoteRef
		%common.attrib;
		%linkendreq.attrib; --to footnote content already supplied--

		--FUTURE USE (V3.0): rename Mark to Label--
		--Mark: symbol (e.g. dagger) for use in pointing to
		footnote in text; default is whatever was used
		in original footnote being referenced--
                Mark		CDATA		#IMPLIED
		%local.footnoteref.attrib;
>
<!--end of footnoteref.module-->]]>

<![ %xref.module; [
<!ENTITY % local.xref.attrib "">
<!ELEMENT XRef - O  EMPTY>
<!ATTLIST XRef
		%common.attrib;

                --Endterm: pointer to description of linked-to object--
		Endterm		IDREF		#IMPLIED

		%linkendreq.attrib; --to linked-to object--
		%local.xref.attrib;
>
<!--end of xref.module-->]]>

<!-- Ubiquitous elements .................................................. -->

<![ %anchor.module; [
<!ENTITY % local.anchor.attrib "">
<!ELEMENT Anchor - O  EMPTY>
<!ATTLIST Anchor
		%id.attrib;
		%pagenum.attrib;
		%remap.attrib;
		%role.attrib;
		%xreflabel.attrib;
		%local.anchor.attrib;
>
<!--end of anchor.module-->]]>

<![ %beginpage.module; [
<!ENTITY % local.beginpage.attrib "">
<!ELEMENT BeginPage - O  EMPTY>
<!ATTLIST BeginPage
		%common.attrib;

		--PageNum: number of page that begins at this point--
		%pagenum.attrib;
		%local.beginpage.attrib;
>
<!--end of beginpage.module-->]]>

<!-- IndexTerms appear in the text flow for generating or linking an
     index. -->

<![ %indexterm.content.module; [
<![ %indexterm.module; [
<!ENTITY % local.indexterm.attrib "">
<!ELEMENT IndexTerm - O (Primary, ((Secondary, ((Tertiary, (See|SeeAlso+)?)
		| See | SeeAlso+)?) | See | SeeAlso+)?) -(%ubiq.mix;)>
<!ATTLIST IndexTerm
		%common.attrib;
		%pagenum.attrib;

		--Scope: indexing applies to this doc (Local), whole doc
		set (Global), or both (All)--
		Scope		(All
				|Global
				|Local)		#IMPLIED

		--Significance: whether term is best source of info for
		this topic (Preferred) or not (Normal)--
		Significance	(Preferred
				|Normal)	Normal

		--FUTURE USE (V3.0): Class: indicates type of IndexTerm;
		default is Singular, or EndOfRange if StartRef is
		supplied; StartOfRange value must be supplied explicitly
		on starts of ranges--
		--Class		(Singular
				|StartOfRange
				|EndOfRange)	#IMPLIED--

		--FUTURE USE (V3.0): rename SpanEnd to StartRef--
		--SpanEnd: points to the IndexTerm that starts
		the indexing range ended by this IndexTerm--
		SpanEnd		IDREF		#CONREF

		--Zone: points to elements where IndexTerms originated;
		for use if IndexTerms are assembled together in source
		instance--
		Zone		IDREFS		#IMPLIED
		%local.indexterm.attrib;
>
<!--end of indexterm.module-->]]>

<![ %primsecter.module; [
<!ENTITY % local.primsecter.attrib "">
<!ELEMENT (Primary | Secondary | Tertiary) - - ((%inline.char.mix;)+)>
<!ATTLIST (Primary | Secondary | Tertiary)
		%common.attrib;

		--SortAs: alternate sort string for index sorting--
		SortAs		CDATA		#IMPLIED
		%local.primsecter.attrib;
>
<!--end of primsecter.module-->]]>

<![ %seeseealso.module; [
<!ENTITY % local.seeseealso.attrib "">
<!ELEMENT (See | SeeAlso) - - ((%inline.char.mix;)+)>
<!ATTLIST (See | SeeAlso)
		%common.attrib;
		%local.seeseealso.attrib;
>
<!--end of seeseealso.module-->]]>
<!--end of indexterm.content.module-->]]>

<!-- End of DocBook information pool module V2.3 .......................... -->
<!-- ...................................................................... -->
