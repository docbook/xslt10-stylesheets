;;; dbk-el-lg.el --- Logical list of DocBook elements
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$

(defvar docbook-menu-elements-logical
  (list "DocBook: Element Reference (Logical)"
	(list "Hierarchy"
	      (list "Top Level"
		    ["set"
		     (browse-url (concat docbook-menu-tdg-base-uri "/set" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["book"
		     (browse-url (concat docbook-menu-tdg-base-uri "/book" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Divisions"
		    ["part"
		     (browse-url (concat docbook-menu-tdg-base-uri "/part" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["partintro"
		     (browse-url (concat docbook-menu-tdg-base-uri "/partintro" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["reference"
		     (browse-url (concat docbook-menu-tdg-base-uri "/reference" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Components"
		    ["dedication"
		     (browse-url (concat docbook-menu-tdg-base-uri "/dedication" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["preface"
		     (browse-url (concat docbook-menu-tdg-base-uri "/preface" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["chapter"
		     (browse-url (concat docbook-menu-tdg-base-uri "/chapter" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["article"
		     (browse-url (concat docbook-menu-tdg-base-uri "/article" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["appendix"
		     (browse-url (concat docbook-menu-tdg-base-uri "/appendix" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["glossary"
		     (browse-url (concat docbook-menu-tdg-base-uri "/glossary" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["bibliography"
		     (browse-url (concat docbook-menu-tdg-base-uri "/bibliography" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["index"
		     (browse-url (concat docbook-menu-tdg-base-uri "/index" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["colophon"
		     (browse-url (concat docbook-menu-tdg-base-uri "/colophon" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Sections"
		    ["sect1 - sect5"
		     (browse-url (concat docbook-menu-tdg-base-uri "/sect1" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["section"
		     (browse-url (concat docbook-menu-tdg-base-uri "/section" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["simplesect"
		     (browse-url (concat docbook-menu-tdg-base-uri "/simplesect" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["bridgehead"
		     (browse-url (concat docbook-menu-tdg-base-uri "/bridgehead" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Meta-Information"
		    ["setinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/setinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["bookinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/bookinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["articleinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/articleinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["chapterinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/chapterinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["prefaceinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/prefaceinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["refsynopsisdivinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/refsynopsisdivinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["appendixinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/appendixinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["bibliographyinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/bibliographyinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["glossaryinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/glossaryinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["indexinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/indexinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["sect1info - sect5info"
		     (browse-url (concat docbook-menu-tdg-base-uri "/sect1info" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["sectioninfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/sectioninfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["screeninfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/screeninfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["objectinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/objectinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["blockinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/blockinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Navigational Components"
		    ["toc"
		     (browse-url (concat docbook-menu-tdg-base-uri "/toc" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["lot"
		     (browse-url (concat docbook-menu-tdg-base-uri "/lot" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["index"
		     (browse-url (concat docbook-menu-tdg-base-uri "/index" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      )
	(list "Block Elements"
	      (list "Lists"
		    ["calloutlist"
		     (browse-url (concat docbook-menu-tdg-base-uri "/calloutlist" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["itemizedlist"
		     (browse-url (concat docbook-menu-tdg-base-uri "/itemizedlist" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["orderedlist"
		     (browse-url (concat docbook-menu-tdg-base-uri "/orderedlist" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["segmentedlist"
		     (browse-url (concat docbook-menu-tdg-base-uri "/segmentedlist" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["simplelist"
		     (browse-url (concat docbook-menu-tdg-base-uri "/simplelist" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["variablelist"
		     (browse-url (concat docbook-menu-tdg-base-uri "/variablelist" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["listitem"
		     (browse-url (concat docbook-menu-tdg-base-uri "/listitem" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Admonitions"
		    ["caution"
		     (browse-url (concat docbook-menu-tdg-base-uri "/caution" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["important"
		     (browse-url (concat docbook-menu-tdg-base-uri "/important" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["note"
		     (browse-url (concat docbook-menu-tdg-base-uri "/note" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["tip"
		     (browse-url (concat docbook-menu-tdg-base-uri "/tip" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["warning"
		     (browse-url (concat docbook-menu-tdg-base-uri "/warning" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Line-specific Environments"
		    ["address"
		     (browse-url (concat docbook-menu-tdg-base-uri "/synopsis" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["literallayout"
		     (browse-url (concat docbook-menu-tdg-base-uri "/literallayout" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["programlisting"
		     (browse-url (concat docbook-menu-tdg-base-uri "/programlisting" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["screen"
		     (browse-url (concat docbook-menu-tdg-base-uri "/screen" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["screenshot"
		     (browse-url (concat docbook-menu-tdg-base-uri "/screenshot" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["synopsis"
		     (browse-url (concat docbook-menu-tdg-base-uri "/synopsis" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Examples, Figures, Tables, and Equations"
		    ["example"
		     (browse-url (concat docbook-menu-tdg-base-uri "/example" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["informalexample"
		     (browse-url (concat docbook-menu-tdg-base-uri "/informalexample" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["figure"
		     (browse-url (concat docbook-menu-tdg-base-uri "/figure" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["informalfigure"
		     (browse-url (concat docbook-menu-tdg-base-uri "/informalfigure" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["table"
		     (browse-url (concat docbook-menu-tdg-base-uri "/table" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["informaltable"
		     (browse-url (concat docbook-menu-tdg-base-uri "/informaltable" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["equation"
		     (browse-url (concat docbook-menu-tdg-base-uri "/equation" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["informalequation"
		     (browse-url (concat docbook-menu-tdg-base-uri "/informalequation" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Paragraphs"
		    ["formalpara"
		     (browse-url (concat docbook-menu-tdg-base-uri "/formalpara" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["para"
		     (browse-url (concat docbook-menu-tdg-base-uri "/para" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["simpara"
		     (browse-url (concat docbook-menu-tdg-base-uri "/simpara" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Graphics"
		    ["figure"
		     (browse-url (concat docbook-menu-tdg-base-uri "/figure" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["screenshot"
		     (browse-url (concat docbook-menu-tdg-base-uri "/screenshot" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["mediaobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/mediaobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["imageobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/imageobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["textobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/textobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["audioobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/audioobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["videoobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/videoobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["caption"
		     (browse-url (concat docbook-menu-tdg-base-uri "/caption" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["graphic"
		     (browse-url (concat docbook-menu-tdg-base-uri "/graphic" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Procedures"
		    ["procedure"
		     (browse-url (concat docbook-menu-tdg-base-uri "/procedure" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["step"
		     (browse-url (concat docbook-menu-tdg-base-uri "/step" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["substep"
		     (browse-url (concat docbook-menu-tdg-base-uri "/substep" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "EBNF"
		    ["productionset"
		     (browse-url (concat docbook-menu-tdg-base-uri "/productionset" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["productionrecap"
		     (browse-url (concat docbook-menu-tdg-base-uri "/productionrecap" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["lhs"
		     (browse-url (concat docbook-menu-tdg-base-uri "/lhs" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["rhs"
		     (browse-url (concat docbook-menu-tdg-base-uri "/rhs" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["constraint"
		     (browse-url (concat docbook-menu-tdg-base-uri "/constraint" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["nonterminal"
		     (browse-url (concat docbook-menu-tdg-base-uri "/nonterminal" docbook-menu-tdg-additional-suffix ".html")) t]

		    ["lineannotation"
		     (browse-url (concat docbook-menu-tdg-base-uri "/lineannotation" docbook-menu-tdg-additional-suffix ".html")) t]	
		    ["sbr"
		     (browse-url (concat docbook-menu-tdg-base-uri "/sbr" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "HTML Forms"
		    ["html:form"
		     (browse-url (concat docbook-menu-tdg-base-uri "/html-form" docbook-menu-tdg-additional-suffix ".html")) t])
	      (list "Miscellaneous"
		    ["abstract"
		     (browse-url (concat docbook-menu-tdg-base-uri "/abstract" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["blockquote"
		     (browse-url (concat docbook-menu-tdg-base-uri "/blockquote" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["cmdsynopsis"
		     (browse-url (concat docbook-menu-tdg-base-uri "/cmdsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["epigraph"
		     (browse-url (concat docbook-menu-tdg-base-uri "/epigraph" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["funcsynopsis"
		     (browse-url (concat docbook-menu-tdg-base-uri "/funcsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["highlights"
		     (browse-url (concat docbook-menu-tdg-base-uri "/highlights" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["msgset"
		     (browse-url (concat docbook-menu-tdg-base-uri "/msgset" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["remark"
		     (browse-url (concat docbook-menu-tdg-base-uri "/remark" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["sidebar"
		     (browse-url (concat docbook-menu-tdg-base-uri "/sidebar" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      )
	(list "Inline Elements"
	      (list "Traditional Publishing Inlines"
		    ["abbrev"
		     (browse-url (concat docbook-menu-tdg-base-uri "/abbrev" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["acronym"
		     (browse-url (concat docbook-menu-tdg-base-uri "/acronym" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["emphasis"
		     (browse-url (concat docbook-menu-tdg-base-uri "/emphasis" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["footnote"
		     (browse-url (concat docbook-menu-tdg-base-uri "/footnote" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["phrase"
		     (browse-url (concat docbook-menu-tdg-base-uri "/phrase" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["quote"
		     (browse-url (concat docbook-menu-tdg-base-uri "/quote" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["phrase"
		     (browse-url (concat docbook-menu-tdg-base-uri "/phrase" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Cross References"
		    ["link"
		     (browse-url (concat docbook-menu-tdg-base-uri "/link" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["olink"
		     (browse-url (concat docbook-menu-tdg-base-uri "/olink" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["ulink"
		     (browse-url (concat docbook-menu-tdg-base-uri "/ulink" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["xref"
		     (browse-url (concat docbook-menu-tdg-base-uri "/xref" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["anchor"
		     (browse-url (concat docbook-menu-tdg-base-uri "/anchor" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["--" t]
		    ["citation"
		     (browse-url (concat docbook-menu-tdg-base-uri "/citation" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["citerefentry"
		     (browse-url (concat docbook-menu-tdg-base-uri "/citerefentry" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["citetitle"
		     (browse-url (concat docbook-menu-tdg-base-uri "/citetitle" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["citebiblioid"
		     (browse-url (concat docbook-menu-tdg-base-uri "/citebiblioid" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["--" t]
		    ["firstterm"
		     (browse-url (concat docbook-menu-tdg-base-uri "/firstterm" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["glossterm"
		     (browse-url (concat docbook-menu-tdg-base-uri "/glossterm" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Special Presentation Markup"
		    ["foreignphrase"
		     (browse-url (concat docbook-menu-tdg-base-uri "/foreignphrase" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["wordasword"
		     (browse-url (concat docbook-menu-tdg-base-uri "/wordasword" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["---" t]
		    ["computeroutput"
		     (browse-url (concat docbook-menu-tdg-base-uri "/computeroutput" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["literal"
		     (browse-url (concat docbook-menu-tdg-base-uri "/literal" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["markup"
		     (browse-url (concat docbook-menu-tdg-base-uri "/markup" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["prompt"
		     (browse-url (concat docbook-menu-tdg-base-uri "/prompt" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["remark"
		     (browse-url (concat docbook-menu-tdg-base-uri "/remark" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["replaceable"
		     (browse-url (concat docbook-menu-tdg-base-uri "/replaceable" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["sgmltag"
		     (browse-url (concat docbook-menu-tdg-base-uri "/sgmltag" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["userinput"
		     (browse-url (concat docbook-menu-tdg-base-uri "/userinput" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Mathematics"
		    ["inlineequation"
		     (browse-url (concat docbook-menu-tdg-base-uri "/inlineequation" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["subscript"
		     (browse-url (concat docbook-menu-tdg-base-uri "/subscript" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["superscript"
		     (browse-url (concat docbook-menu-tdg-base-uri "/superscript" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["mml:math"
		     (browse-url (concat docbook-menu-tdg-base-uri "/mml-math" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Computer Software and Hardware"
		    (list "User Interfaces"
			  ["accel"
			   (browse-url (concat docbook-menu-tdg-base-uri "/accel" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["guibutton"
			   (browse-url (concat docbook-menu-tdg-base-uri "/guibutton" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["guiicon"
			   (browse-url (concat docbook-menu-tdg-base-uri "/guiicon" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["guilabel"
			   (browse-url (concat docbook-menu-tdg-base-uri "/guilabel" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["guimenu"
			   (browse-url (concat docbook-menu-tdg-base-uri "/guimenu" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["guimenuitem"
			   (browse-url (concat docbook-menu-tdg-base-uri "/guimenuitem" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["guisubmenu"
			   (browse-url (concat docbook-menu-tdg-base-uri "/guisubmenu" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["---" t]
			  ["keycap"
			   (browse-url (concat docbook-menu-tdg-base-uri "/keycap" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["keycode"
			   (browse-url (concat docbook-menu-tdg-base-uri "/keycode" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["keycombo"
			   (browse-url (concat docbook-menu-tdg-base-uri "/keycombo" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["keysym"
			   (browse-url (concat docbook-menu-tdg-base-uri "/keysym" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["----" t]
			  ["menuchoice"
			   (browse-url (concat docbook-menu-tdg-base-uri "/menuchoice" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["mousebutton"
			   (browse-url (concat docbook-menu-tdg-base-uri "/mousebutton" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["shortcut"
			   (browse-url (concat docbook-menu-tdg-base-uri "/shortcut" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Operating Systems"
			  ["computeroutput"
			   (browse-url (concat docbook-menu-tdg-base-uri "/computeroutput" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["userinput"
			   (browse-url (concat docbook-menu-tdg-base-uri "/userinput" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["---" t]
			  ["envar"
			   (browse-url (concat docbook-menu-tdg-base-uri "/envar" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["filename"
			   (browse-url (concat docbook-menu-tdg-base-uri "/filename" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["medialabel"
			   (browse-url (concat docbook-menu-tdg-base-uri "/medialabel" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["prompt"
			   (browse-url (concat docbook-menu-tdg-base-uri "/prompt" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["systemitem"
			   (browse-url (concat docbook-menu-tdg-base-uri "/systemitem" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["option"
			   (browse-url (concat docbook-menu-tdg-base-uri "/option" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["optional"
			   (browse-url (concat docbook-menu-tdg-base-uri "/optional" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["parameter"
			   (browse-url (concat docbook-menu-tdg-base-uri "/parameter" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Programming Constructs"
			  ["action"
			   (browse-url (concat docbook-menu-tdg-base-uri "/action" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["constant"
			   (browse-url (concat docbook-menu-tdg-base-uri "/constant" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["function"
			   (browse-url (concat docbook-menu-tdg-base-uri "/function" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["lineannotation"
			   (browse-url (concat docbook-menu-tdg-base-uri "/lineannotation" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["literal"
			   (browse-url (concat docbook-menu-tdg-base-uri "/literal" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["parameter"
			   (browse-url (concat docbook-menu-tdg-base-uri "/parameter" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["property"
			   (browse-url (concat docbook-menu-tdg-base-uri "/property" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["replaceable"
			   (browse-url (concat docbook-menu-tdg-base-uri "/replaceable" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["returnvalue"
			   (browse-url (concat docbook-menu-tdg-base-uri "/returnvalue" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["structfield"
			   (browse-url (concat docbook-menu-tdg-base-uri "/structfield" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["structname"
			   (browse-url (concat docbook-menu-tdg-base-uri "/structname" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["symbol"
			   (browse-url (concat docbook-menu-tdg-base-uri "/symbol" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["token"
			   (browse-url (concat docbook-menu-tdg-base-uri "/token" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["type"
			   (browse-url (concat docbook-menu-tdg-base-uri "/type" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["varname"
			   (browse-url (concat docbook-menu-tdg-base-uri "/varname" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Object-Oriented Programming Constructs"
			  ["classname"
			   (browse-url (concat docbook-menu-tdg-base-uri "/classname" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["classsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/classsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["constructorsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/constructorsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["destructorsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/destructorsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["exceptionname"
			   (browse-url (concat docbook-menu-tdg-base-uri "/exceptionname" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["fieldsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/fieldsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["initializer"
			   (browse-url (concat docbook-menu-tdg-base-uri "/initializer" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["interfacename"
			   (browse-url (concat docbook-menu-tdg-base-uri "/interfacename" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["methodname"
			   (browse-url (concat docbook-menu-tdg-base-uri "/methodname" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["methodsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/methodsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["modifier"
			   (browse-url (concat docbook-menu-tdg-base-uri "/modifier" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["ooclass"
			   (browse-url (concat docbook-menu-tdg-base-uri "/ooclass" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["ooexception"
			   (browse-url (concat docbook-menu-tdg-base-uri "/ooexception" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["oointerface"
			   (browse-url (concat docbook-menu-tdg-base-uri "/oointerface" docbook-menu-tdg-additional-suffix ".html")) t]
			  )	      
		    (list "Error Messages"
			  ["errortype"
			   (browse-url (concat docbook-menu-tdg-base-uri "/errortype" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["errorcode"
			   (browse-url (concat docbook-menu-tdg-base-uri "/errorcode" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["errorname"
			   (browse-url (concat docbook-menu-tdg-base-uri "/errorname" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["errortext"
			   (browse-url (concat docbook-menu-tdg-base-uri "/errortext" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Function Synopsis"
			  ["function"
			   (browse-url (concat docbook-menu-tdg-base-uri "/function" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["parameter"
			   (browse-url (concat docbook-menu-tdg-base-uri "/parameter" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["returnvalue"
			   (browse-url (concat docbook-menu-tdg-base-uri "/returnvalue" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["paramdef"
			   (browse-url (concat docbook-menu-tdg-base-uri "/paramdef" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["varargs"
			   (browse-url (concat docbook-menu-tdg-base-uri "/varargs" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["void"
			   (browse-url (concat docbook-menu-tdg-base-uri "/void" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["funcdef"
			   (browse-url (concat docbook-menu-tdg-base-uri "/funcdef" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["funcparams"
			   (browse-url (concat docbook-menu-tdg-base-uri "/funcparams" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["funcprototype"
			   (browse-url (concat docbook-menu-tdg-base-uri "/funcprototype" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["funcsynopsisinfo"
			   (browse-url (concat docbook-menu-tdg-base-uri "/funcsynopsisinfo" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Command Synopsis"
			  ["arg"
			   (browse-url (concat docbook-menu-tdg-base-uri "/arg" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["cmdsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/cmdsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["group"
			   (browse-url (concat docbook-menu-tdg-base-uri "/group" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["synopfragment"
			   (browse-url (concat docbook-menu-tdg-base-uri "/synopfragment" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["synopfragmentref"
			   (browse-url (concat docbook-menu-tdg-base-uri "/synopfragmentref" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["refsynopsisdiv"
			   (browse-url (concat docbook-menu-tdg-base-uri "/refsynopsisdiv" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["sbr"
			   (browse-url (concat docbook-menu-tdg-base-uri "/sbr" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Synopsis"
			  ["synopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/synopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["cmdsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/cmdsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["funcsynopsis"
			   (browse-url (concat docbook-menu-tdg-base-uri "/funcsynopsis" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Callouts"
			  ["screenco"
			   (browse-url (concat docbook-menu-tdg-base-uri "/screenco" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["programlistingco"
			   (browse-url (concat docbook-menu-tdg-base-uri "/programlistingco" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["co"
			   (browse-url (concat docbook-menu-tdg-base-uri "/co" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["coref"
			   (browse-url (concat docbook-menu-tdg-base-uri "/coref" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["areaspec"
			   (browse-url (concat docbook-menu-tdg-base-uri "/areaspec" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["graphicco"
			   (browse-url (concat docbook-menu-tdg-base-uri "/graphicco" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["mediaobjectco"
			   (browse-url (concat docbook-menu-tdg-base-uri "/mediaobjectco" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["calloutlist"
			   (browse-url (concat docbook-menu-tdg-base-uri "/calloutlist" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["imageobjectco"
			   (browse-url (concat docbook-menu-tdg-base-uri "/imageobjectco" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    (list "Literals"
			  ["command"
			   (browse-url (concat docbook-menu-tdg-base-uri "/command" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["replaceable"
			   (browse-url (concat docbook-menu-tdg-base-uri "/replaceable" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["varname"
			   (browse-url (concat docbook-menu-tdg-base-uri "/varname" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["constant"
			   (browse-url (concat docbook-menu-tdg-base-uri "/constant" docbook-menu-tdg-additional-suffix ".html")) t]
			  ["literal"
			   (browse-url (concat docbook-menu-tdg-base-uri "/literal" docbook-menu-tdg-additional-suffix ".html")) t]
			  )
		    )
	      (list "General Purpose"
		    ["application"
		     (browse-url (concat docbook-menu-tdg-base-uri "/application" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["database"
		     (browse-url (concat docbook-menu-tdg-base-uri "/database" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["email"
		     (browse-url (concat docbook-menu-tdg-base-uri "/email" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["filename"
		     (browse-url (concat docbook-menu-tdg-base-uri "/filename" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["hardware"
		     (browse-url (concat docbook-menu-tdg-base-uri "/hardware" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["inlinegraphic"
		     (browse-url (concat docbook-menu-tdg-base-uri "/inlinegraphic" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["literal"
		     (browse-url (concat docbook-menu-tdg-base-uri "/literal" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["medialabel"
		     (browse-url (concat docbook-menu-tdg-base-uri "/medialabel" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["option"
		     (browse-url (concat docbook-menu-tdg-base-uri "/option" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["optional"
		     (browse-url (concat docbook-menu-tdg-base-uri "/optional" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["productname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/productname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["replaceable"
		     (browse-url (concat docbook-menu-tdg-base-uri "/replaceable" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["symbol"
		     (browse-url (concat docbook-menu-tdg-base-uri "/symbol" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["token"
		     (browse-url (concat docbook-menu-tdg-base-uri "/token" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["type"
		     (browse-url (concat docbook-menu-tdg-base-uri "/type" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Date Meta-information"
		    ["printhistory"
		     (browse-url (concat docbook-menu-tdg-base-uri "/printhistory" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["pubdate"
		     (browse-url (concat docbook-menu-tdg-base-uri "/pubdate" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["revhistory"
		     (browse-url (concat docbook-menu-tdg-base-uri "/revhistory" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["date"
		     (browse-url (concat docbook-menu-tdg-base-uri "/date" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["releaseinfo"
		     (browse-url (concat docbook-menu-tdg-base-uri "/releaseinfo" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["edition"
		     (browse-url (concat docbook-menu-tdg-base-uri "/edition" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Product Names, Trademarks, Copyrights"
		    ["productname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/productname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["trademark"
		     (browse-url (concat docbook-menu-tdg-base-uri "/trademark" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["copyright"
		     (browse-url (concat docbook-menu-tdg-base-uri "/copyright" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["legalnotice"
		     (browse-url (concat docbook-menu-tdg-base-uri "/legalnotice" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Organizations"
		    ["corpname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/corpname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["publishername"
		     (browse-url (concat docbook-menu-tdg-base-uri "/publishername" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["orgname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/orgname" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Persons"
		    ["personname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/personname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["personblurb"
		     (browse-url (concat docbook-menu-tdg-base-uri "/personblurb" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["firstname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/firstname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["othername"
		     (browse-url (concat docbook-menu-tdg-base-uri "/othername" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["surname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/surname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["honorific"
		     (browse-url (concat docbook-menu-tdg-base-uri "/honorific" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["lineage"
		     (browse-url (concat docbook-menu-tdg-base-uri "/lineage" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["affiliation"
		     (browse-url (concat docbook-menu-tdg-base-uri "/affiliation" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Affiliations"
		    ["jobtitle"
		     (browse-url (concat docbook-menu-tdg-base-uri "/jobtitle" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["affiliation"
		     (browse-url (concat docbook-menu-tdg-base-uri "/affiliation" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["shortaffil"
		     (browse-url (concat docbook-menu-tdg-base-uri "/shortaffil" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["orgdiv"
		     (browse-url (concat docbook-menu-tdg-base-uri "/orgdiv" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["orgname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/orgname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["corpname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/corpname" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Authorship"
		    ["author"
		     (browse-url (concat docbook-menu-tdg-base-uri "/author" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["authorblurb"
		     (browse-url (concat docbook-menu-tdg-base-uri "/authorblurb" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["authorgroup"
		     (browse-url (concat docbook-menu-tdg-base-uri "/authorgroup" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["corpauthor"
		     (browse-url (concat docbook-menu-tdg-base-uri "/corpauthor" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["contrib"
		     (browse-url (concat docbook-menu-tdg-base-uri "/contrib" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["editor"
		     (browse-url (concat docbook-menu-tdg-base-uri "/editor" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["collab"
		     (browse-url (concat docbook-menu-tdg-base-uri "/collab" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["collabname"
		     (browse-url (concat docbook-menu-tdg-base-uri "/collabname" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["othercredit"
		     (browse-url (concat docbook-menu-tdg-base-uri "/othercredit" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Addresses"
		    ["email"
		     (browse-url (concat docbook-menu-tdg-base-uri "/email" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["otheraddr"
		     (browse-url (concat docbook-menu-tdg-base-uri "/otheraddr" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["country"
		     (browse-url (concat docbook-menu-tdg-base-uri "/country" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["fax"
		     (browse-url (concat docbook-menu-tdg-base-uri "/fax" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["address"
		     (browse-url (concat docbook-menu-tdg-base-uri "/address" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["city"
		     (browse-url (concat docbook-menu-tdg-base-uri "/city" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["street"
		     (browse-url (concat docbook-menu-tdg-base-uri "/street" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["postcode"
		     (browse-url (concat docbook-menu-tdg-base-uri "/postcode" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["pob"
		     (browse-url (concat docbook-menu-tdg-base-uri "/pob" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["state"
		     (browse-url (concat docbook-menu-tdg-base-uri "/state" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["phone"
		     (browse-url (concat docbook-menu-tdg-base-uri "/phone" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Keywords"
		    ["subject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/subject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["subjectset"
		     (browse-url (concat docbook-menu-tdg-base-uri "/subjectset" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["subjectterm"
		     (browse-url (concat docbook-menu-tdg-base-uri "/subjectterm" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["keyword"
		     (browse-url (concat docbook-menu-tdg-base-uri "/keyword" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["keywordset"
		     (browse-url (concat docbook-menu-tdg-base-uri "/keywordset" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Numbers"
		    ["invpartnumber"
		     (browse-url (concat docbook-menu-tdg-base-uri "/invpartnumber" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["isbn"
		     (browse-url (concat docbook-menu-tdg-base-uri "/isbn" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["issn"
		     (browse-url (concat docbook-menu-tdg-base-uri "/issn" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["biblioid"
		     (browse-url (concat docbook-menu-tdg-base-uri "/biblioid" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["issuenum"
		     (browse-url (concat docbook-menu-tdg-base-uri "/issuenum" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["productnumber"
		     (browse-url (concat docbook-menu-tdg-base-uri "/productnumber" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["pubsnumber"
		     (browse-url (concat docbook-menu-tdg-base-uri "/pubsnumber" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["seriesvolnums"
		     (browse-url (concat docbook-menu-tdg-base-uri "/seriesvolnums" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["volumenum"
		     (browse-url (concat docbook-menu-tdg-base-uri "/volumenum" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Titles"
		    ["subtitle"
		     (browse-url (concat docbook-menu-tdg-base-uri "/subtitle" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["title"
		     (browse-url (concat docbook-menu-tdg-base-uri "/title" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["titleabbrev"
		     (browse-url (concat docbook-menu-tdg-base-uri "/titleabbrev" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      (list "Graphics (inline)"
		    ["inlinegraphic"
		     (browse-url (concat docbook-menu-tdg-base-uri "/inlinegraphic" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["inlinemediaobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/inlinemediaobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["imageobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/imageobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["textobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/textobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["audioobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/audioobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["videoobject"
		     (browse-url (concat docbook-menu-tdg-base-uri "/videoobject" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["svg:svg"
		     (browse-url (concat docbook-menu-tdg-base-uri "/svg-svg" docbook-menu-tdg-additional-suffix ".html")) t]
		    ["alt"
		     (browse-url (concat docbook-menu-tdg-base-uri "/alt" docbook-menu-tdg-additional-suffix ".html")) t]
		    )
	      )
	(list "Tables"
	      ["table"
	       (browse-url (concat docbook-menu-tdg-base-uri "/table" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["informaltable"
	       (browse-url (concat docbook-menu-tdg-base-uri "/informaltable" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["tgroup"
	       (browse-url (concat docbook-menu-tdg-base-uri "/tgroup" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["colspec"
	       (browse-url (concat docbook-menu-tdg-base-uri "/colspec" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["spanspec"
	       (browse-url (concat docbook-menu-tdg-base-uri "/spanspec" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["thead"
	       (browse-url (concat docbook-menu-tdg-base-uri "/thead" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["tfoot"
	       (browse-url (concat docbook-menu-tdg-base-uri "/tfoot" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["tbody"
	       (browse-url (concat docbook-menu-tdg-base-uri "/tbody" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["row"
	       (browse-url (concat docbook-menu-tdg-base-uri "/row" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["entry"
	       (browse-url (concat docbook-menu-tdg-base-uri "/entry" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["entrytbl"
	       (browse-url (concat docbook-menu-tdg-base-uri "/entrytbl" docbook-menu-tdg-additional-suffix ".html")) t]
	      )
	(list "Reference Pages (Refentries)"
	      ["refmeta"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refmeta" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["refentrytitle"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refentrytitle" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["manvolnum"
	       (browse-url (concat docbook-menu-tdg-base-uri "/manvolnum" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["refmiscinfo"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refmiscinfo" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["---" t]
	      ["refnamediv"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refnamediv" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["refdescriptor"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refdescriptor" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["refname"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refname" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["refpurpose"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refpurpose" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["refclass"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refclass" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["----" t]
	      ["refsynopsisdiv"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refsynopsisdiv" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["-----" t]
	      ["refsect1 - refsect3"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refsect1" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["refsection"
	       (browse-url (concat docbook-menu-tdg-base-uri "/refsection" docbook-menu-tdg-additional-suffix ".html")) t]
	      )
	(list "Glossaries"
	      ["glossdiv"
	       (browse-url (concat docbook-menu-tdg-base-uri "/glossdiv" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["glossdef"
	       (browse-url (concat docbook-menu-tdg-base-uri "/glossdef" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["glosssee"
	       (browse-url (concat docbook-menu-tdg-base-uri "/glosssee" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["glossseealso"
	       (browse-url (concat docbook-menu-tdg-base-uri "/glossseealso" docbook-menu-tdg-additional-suffix ".html")) t]
	      )
	(list "Bibliographies"
	      ["bibliodiv"
	       (browse-url (concat docbook-menu-tdg-base-uri "/bibliodiv" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["biblioentry"
	       (browse-url (concat docbook-menu-tdg-base-uri "/biblioentry" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["bibliomixed"
	       (browse-url (concat docbook-menu-tdg-base-uri "/bibliomixed" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["biblioset"
	       (browse-url (concat docbook-menu-tdg-base-uri "/biblioset" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["bibliomset"
	       (browse-url (concat docbook-menu-tdg-base-uri "/bibliomset" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["bibliomisc"
	       (browse-url (concat docbook-menu-tdg-base-uri "/bibliomisc" docbook-menu-tdg-additional-suffix ".html")) t]
	      )
	(list "Index Markup"
	      ["indexterm"
	       (browse-url (concat docbook-menu-tdg-base-uri "/indexterm" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["indexentry"
	       (browse-url (concat docbook-menu-tdg-base-uri "/indexentry" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["----" t]
	      ["primary"
	       (browse-url (concat docbook-menu-tdg-base-uri "/primary" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["primaryie"
	       (browse-url (concat docbook-menu-tdg-base-uri "/primaryie" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["secondary"
	       (browse-url (concat docbook-menu-tdg-base-uri "/secondary" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["secondaryie"
	       (browse-url (concat docbook-menu-tdg-base-uri "/secondaryie" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["tertiary"
	       (browse-url (concat docbook-menu-tdg-base-uri "/tertiary" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["tertiaryie"
	       (browse-url (concat docbook-menu-tdg-base-uri "/tertiaryie" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["---" t]
	      ["see"
	       (browse-url (concat docbook-menu-tdg-base-uri "/see" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["seealso"
	       (browse-url (concat docbook-menu-tdg-base-uri "/seealso" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["seealsoie"
	       (browse-url (concat docbook-menu-tdg-base-uri "/seealsoie" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["seeie"
	       (browse-url (concat docbook-menu-tdg-base-uri "/seeie" docbook-menu-tdg-additional-suffix ".html")) t]
	      )
	(list "Questions and Answers"
	      ["qandaset"
	       (browse-url (concat docbook-menu-tdg-base-uri "/qandaset" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["qandadiv"
	       (browse-url (concat docbook-menu-tdg-base-uri "/qandadiv" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["qandaentry"
	       (browse-url (concat docbook-menu-tdg-base-uri "/qandaentry" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["question"
	       (browse-url (concat docbook-menu-tdg-base-uri "/question" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["answer"
	       (browse-url (concat docbook-menu-tdg-base-uri "/answer" docbook-menu-tdg-additional-suffix ".html")) t]
	      )
	(list "Quotes"
	      ["blockquote"
	       (browse-url (concat docbook-menu-tdg-base-uri "/blockquote" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["epigraph"
	       (browse-url (concat docbook-menu-tdg-base-uri "/epigraph" docbook-menu-tdg-additional-suffix ".html")) t]
	      ["attribution"
	       (browse-url (concat docbook-menu-tdg-base-uri "/attribution" docbook-menu-tdg-additional-suffix ".html")) t]
	      )
	)
  "DocBook elements submenu for 'docbook-menu', grouped logically."
  )
