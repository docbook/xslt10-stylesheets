;;; dbk-xslhtm.el --- List of DocBook XSLT HTML parameters
;; for DocBook XSLT stylesheets version 1.64.0
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$

(defvar docbook-menu-xsl-params-html
  (list "DocBook XSL: Parameter Reference - HTML"
	(list "I. Admonitions"
	      ["admon.graphics.extension - Extension for admonition graphics"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/admon.graphics.extension.html")) t]
	      ["admon.graphics.path - Path to admonition graphics"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/admon.graphics.path.html")) t]
	      ["admon.graphics - Use graphics in admonitions?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/admon.graphics.html")) t]
	      ["admon.textlabel - Use text label in admonitions?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/admon.textlabel.html")) t]
	      ["admon.style - CSS style attributes for admonitions"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/admon.style.html")) t]
	      )
	(list "II. Callouts"
	      ["callout.defaultcolumn - Indicates what column callouts appear in by default"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.defaultcolumn.html")) t]
	      ["callout.graphics.extension - Extension for callout graphics"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.graphics.extension.html")) t]
	      ["callout.graphics.number.limit - Number of the largest callout graphic"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.graphics.number.limit.html")) t]
	      ["callout.graphics.path - Path to callout graphics"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.graphics.path.html")) t]
	      ["callout.graphics - Use graphics for callouts?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.graphics.html")) t]
	      ["callout.list.table - Present callout lists using a table?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.list.table.html")) t]
	      ["callout.unicode.number.limit - Number of the largest callout graphic"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.unicode.number.limit.html")) t]
	      ["callout.unicode.start.character - First Unicode character to use, decimal value."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.unicode.start.character.html")) t]
	      ["callout.unicode - Use Unicode characters rather than images for callouts."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callout.unicode.html")) t]
	      ["callouts.extension - Enable the callout extension"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/callouts.extension.html")) t]
	      )
	(list "III. EBNF"
	      ["ebnf.table.bgcolor - Background color for EBNF tables"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/ebnf.table.bgcolor.html")) t]
	      ["ebnf.table.border - Selects border on EBNF tables"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/ebnf.table.border.html")) t]
	      ["ebnf.assignment - The EBNF production assignment operator"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/ebnf.assignment.html")) t]
	      ["ebnf.statement.terminator - Punctuation that ends an EBNF statement."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/ebnf.statement.terminator.html")) t]
	      )
	(list "IV. ToC/LoT/Index Generation"
	      ["annotate.toc - Annotate the Table of Contents?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/annotate.toc.html")) t]
	      ["autotoc.label.separator - Separator between labels and titles in the ToC"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/autotoc.label.separator.html")) t]
	      ["process.source.toc - FIXME:"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/process.source.toc.html")) t]
	      ["process.empty.source.toc - FIXME:"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/process.empty.source.toc.html")) t]
	      ["bridgehead.in.toc - Should bridgehead elements appear in the TOC?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/bridgehead.in.toc.html")) t]
	      ["manual.toc - An explicit TOC to be used for the TOC"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/manual.toc.html")) t]
	      ["toc.list.type - Type of HTML list element to use for Tables of Contents"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/toc.list.type.html")) t]
	      ["toc.section.depth - How deep should recursive sections appear in the TOC?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/toc.section.depth.html")) t]
	      ["toc.max.depth - How maximaly deep should be each TOC?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/toc.max.depth.html")) t]
	      ["generate.toc - Control generation of ToCs and LoTs"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/generate.toc.html")) t]
	      ["generate.section.toc.level - Control depth of TOC generation in sections"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/generate.section.toc.level.html")) t]
	      ["generate.index - Do you want an index?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/generate.index.html")) t]
	      )
	(list "V. Extensions"
	      ["linenumbering.everyNth - Indicate which lines should be numbered"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/linenumbering.everyNth.html")) t]
	      ["linenumbering.extension - Enable the line numbering extension"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/linenumbering.extension.html")) t]
	      ["linenumbering.separator - Specify a separator between line numbers and lines"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/linenumbering.separator.html")) t]
	      ["linenumbering.width - Indicates the width of line numbers"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/linenumbering.width.html")) t]
	      ["tablecolumns.extension - Enable the table columns extension function"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/tablecolumns.extension.html")) t]
	      ["textinsert.extension - Enable the textinsert extension element"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/textinsert.extension.html")) t]
	      ["graphicsize.extension - Enable the getWidth()/getDepth() extension functions"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/graphicsize.extension.html")) t]
	      ["use.extensions - Enable extensions"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/use.extensions.html")) t]
	      )
	(list "VI. Automatic labelling"
	      ["chapter.autolabel - Are chapters automatically enumerated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chapter.autolabel.html")) t]
	      ["appendix.autolabel - Are Appendixes automatically enumerated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/appendix.autolabel.html")) t]
	      ["part.autolabel - Are parts and references enumerated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/part.autolabel.html")) t]
	      ["preface.autolabel - Are prefaces enumerated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/preface.autolabel.html")) t]
	      ["qandadiv.autolabel - Are divisions in QAndASets enumerated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/qandadiv.autolabel.html")) t]
	      ["section.autolabel - Are sections enumerated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/section.autolabel.html")) t]
	      ["section.label.includes.component.label - Do section labels include the component label?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/section.label.includes.component.label.html")) t]
	      ["label.from.part - Renumber chapters in each part?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/label.from.part.html")) t]
	      )
	(list "VII. HTML"
	      ["html.base - An HTML base URI"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.base.html")) t]
	      ["html.stylesheet.type - The type of the stylesheet used in the generated HTML"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.stylesheet.type.html")) t]
	      ["html.stylesheet - Name of the stylesheet(s) to use in the generated HTML"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.stylesheet.html")) t]
	      ["use.id.as.filename - Use ID value of chunk elements as the filename?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/use.id.as.filename.html")) t]
	      ["css.decoration - Enable CSS decoration of elements"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/css.decoration.html")) t]
	      ["spacing.paras - Insert additional <p> elements for spacing?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/spacing.paras.html")) t]
	      ["emphasis.propagates.style - Pass emphasis role attribute through to HTML?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/emphasis.propagates.style.html")) t]
	      ["para.propagates.style - Pass para role attribute through to HTML?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/para.propagates.style.html")) t]
	      ["phrase.propagates.style - Pass phrase role attribute through to HTML?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/phrase.propagates.style.html")) t]
	      ["entry.propagates.style - Pass entry role attribute through to HTML?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/entry.propagates.style.html")) t]
	      ["html.longdesc - Should longdesc URIs be created?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.longdesc.html")) t]
	      ["html.longdesc.link - Should a link to the longdesc be included in the HTML?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.longdesc.link.html")) t]
	      ["make.valid.html - Attempt to make sure the HTML output is valid HTML"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/make.valid.html.html")) t]
	      ["html.cleanup - Attempt to clean up the resulting HTML?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.cleanup.html")) t]
	      ["draft.mode - Select draft mode"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/draft.mode.html")) t]
	      ["draft.watermark.image - The URI of the image to be used for draft watermarks"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/draft.watermark.image.html")) t]
	      ["generate.id.attributes -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/generate.id.attributes.html")) t]
	      ["generate.meta.abstract - Generate HTML META element from abstract?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/generate.meta.abstract.html")) t]
	      )
	(list "VIII. XSLT Processing"
	      ["rootid - Specify the root element to format"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/rootid.html")) t]
	      ["suppress.navigation - Disable header and footer navigation"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/suppress.navigation.html")) t]
	      ["suppress.header.navigation - Disable header navigation"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/suppress.header.navigation.html")) t]
	      ["suppress.footer.navigation - Disable footer navigation"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/suppress.footer.navigation.html")) t]
	      ["header.rule - Rule under headers?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/header.rule.html")) t]
	      ["footer.rule - Rule over footers?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/footer.rule.html")) t]
	      )
	(list "IX. Meta/*Info"
	      ["inherit.keywords - Inherit keywords from ancestor elements?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/inherit.keywords.html")) t]
	      ["make.single.year.ranges - Print single-year ranges (e.g., 1998-1999)"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/make.single.year.ranges.html")) t]
	      ["make.year.ranges - Collate copyright years into ranges?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/make.year.ranges.html")) t]
	      ["author.othername.in.middle - Is othername in author a middle name?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/author.othername.in.middle.html")) t]
	      ["generate.legalnotice.link - TBD"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/generate.legalnotice.link.html")) t]
	      )
	(list "X. Reference Pages"
	      ["funcsynopsis.decoration - Decorate elements of a FuncSynopsis?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/funcsynopsis.decoration.html")) t]
	      ["funcsynopsis.style - What style of 'FuncSynopsis' should be generated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/funcsynopsis.style.html")) t]
	      ["funcsynopsis.tabular.threshold - Width beyond which a tabular presentation will be used"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/funcsynopsis.tabular.threshold.html")) t]
	      ["function.parens - Generate parens after a function?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/function.parens.html")) t]
	      ["refentry.generate.name - Output NAME header before 'RefName'(s)?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/refentry.generate.name.html")) t]
	      ["refentry.generate.title - Output title before 'RefName'(s)?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/refentry.generate.title.html")) t]
	      ["refentry.xref.manvolnum - Output manvolnum as part of refentry cross-reference?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/refentry.xref.manvolnum.html")) t]
	      ["citerefentry.link - Generate URL links when cross-referencing RefEntrys?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/citerefentry.link.html")) t]
	      ["refentry.separator - Generate a separator between consecutive RefEntry elements?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/refentry.separator.html")) t]
	      )
	(list "XI. Tables"
	      ["default.table.width - The default width of tables"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/default.table.width.html")) t]
	      ["nominal.table.width - The (absolute) nominal width of tables"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/nominal.table.width.html")) t]
	      ["table.borders.with.css - Use CSS to specify table, row, and cell borders?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.borders.with.css.html")) t]
	      ["table.cell.border.style -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.cell.border.style.html")) t]
	      ["table.cell.border.thickness -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.cell.border.thickness.html")) t]
	      ["table.cell.border.color -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.cell.border.color.html")) t]
	      ["table.frame.border.style -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.frame.border.style.html")) t]
	      ["table.frame.border.thickness - Specifies the thickness of the frame border"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.frame.border.thickness.html")) t]
	      ["table.frame.border.color -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.frame.border.color.html")) t]
	      ["html.cellspacing - Default value for cellspacing in HTML tables"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.cellspacing.html")) t]
	      ["html.cellpadding - Default value for cellpadding in HTML tables"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.cellpadding.html")) t]
	      )
	(list "XII. QAndASet"
	      ["qanda.defaultlabel - Sets the default for defaultlabel on QandASet."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/qanda.defaultlabel.html")) t]
	      ["qanda.inherit.numeration - Does enumeration of QandASet components inherit the numeration of parent elements?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/qanda.inherit.numeration.html")) t]
	      )
	(list "XIII. Linking"
	      ["target.database.document - Name of master database file for resolving olinks"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/target.database.document.html")) t]
	      ["targets.filename - Name of cross reference targets data file"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/targets.filename.html")) t]
	      ["collect.xref.targets - Controls whether cross reference data is collected"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/collect.xref.targets.html")) t]
	      ["olink.base.uri - Base URI used in olink hrefs"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/olink.base.uri.html")) t]
	      ["use.local.olink.style - Process olinks using xref style of current document"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/use.local.olink.style.html")) t]
	      ["current.docid - targetdoc identifier for the document being processed"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/current.docid.html")) t]
	      ["olink.doctitle - show the document title for external olinks?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/olink.doctitle.html")) t]
	      ["link.mailto.url - Mailto URL for the LINK REL=made HTML HEAD element"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/link.mailto.url.html")) t]
	      ["ulink.target - The HTML anchor target for ULinks"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/ulink.target.html")) t]
	      ["olink.fragid - Names the fragment identifier portion of an OLink resolver query"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/olink.fragid.html")) t]
	      ["olink.outline.ext - The extension of OLink outline files"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/olink.outline.ext.html")) t]
	      ["olink.pubid - Names the public identifier portion of an OLink resolver query"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/olink.pubid.html")) t]
	      ["olink.sysid - Names the system identifier portion of an OLink resolver query"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/olink.sysid.html")) t]
	      ["olink.resolver - The root name of the OLink resolver (usually a script)"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/olink.resolver.html")) t]
	      )
	(list "XIV. Bibliography"
	      ["biblioentry.item.separator - Text to separate bibliography entries"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/biblioentry.item.separator.html")) t]
	      ["bibliography.collection - Name of the bibliography collection file"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/bibliography.collection.html")) t]
	      ["bibliography.numbered - Should bibliography entries be numbered?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/bibliography.numbered.html")) t]
	      )
	(list "XV. Glossary"
	      ["glossterm.auto.link - Generate links from glossterm to glossentry automaticaly?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/glossterm.auto.link.html")) t]
	      ["firstterm.only.link - Does automatic glossterm linking only apply to firstterms?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/firstterm.only.link.html")) t]
	      ["glossary.collection - Name of the glossary collection file"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/glossary.collection.html")) t]
	      ["glossentry.show.acronym - Display glossentry acronyms?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/glossentry.show.acronym.html")) t]
	      )
	(list "XVI. Miscellaneous"
	      ["formal.procedures - Selects formal or informal procedures"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/formal.procedures.html")) t]
	      ["formal.title.placement -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/formal.title.placement.html")) t]
	      ["runinhead.default.title.end.punct - Default punctuation character on a run-in-head"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/runinhead.default.title.end.punct.html")) t]
	      ["runinhead.title.end.punct - Characters that count as punctuation on a run-in-head"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/runinhead.title.end.punct.html")) t]
	      ["show.comments - Display comment elements?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/show.comments.html")) t]
	      ["show.revisionflag - Enable decoration of elements that have a revisionflag"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/show.revisionflag.html")) t]
	      ["shade.verbatim - Should verbatim environments be shaded?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/shade.verbatim.html")) t]
	      ["shade.verbatim.style - Properties that specify the style of shaded verbatim listings"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/shade.verbatim.style.html")) t]
	      ["punct.honorific - Punctuation after an honorific in a personal name."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/punct.honorific.html")) t]
	      ["segmentedlist.as.table - Format segmented lists as tables?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/segmentedlist.as.table.html")) t]
	      ["variablelist.as.table - Format variablelists as tables?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/variablelist.as.table.html")) t]
	      ["tex.math.in.alt - TeX notation used for equations"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/tex.math.in.alt.html")) t]
	      ["tex.math.file - Name of temporary file for generating images from equations"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/tex.math.file.html")) t]
	      ["tex.math.delims - Should be equations outputed for processing by TeX automatically surrounded by math mode delimiters"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/tex.math.delims.html")) t]
	      ["pixels.per.inch - How many pixels are there per inch?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/pixels.per.inch.html")) t]
	      ["points.per.em - Specify the nominal size of an em-space in points"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/points.per.em.html")) t]
	      ["use.svg - Allow SVG in the result tree?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/use.svg.html")) t]
	      ["use.role.as.xrefstyle - Use role attribute for xrefstyle on xref?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/use.role.as.xrefstyle.html")) t]
	      ["menuchoice.separator -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/menuchoice.separator.html")) t]
	      ["menuchoice.menu.separator -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/menuchoice.menu.separator.html")) t]
	      ["default.float.class - Specifies the default float class"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/default.float.class.html")) t]
	      ["footnote.number.format - Identifies the format used for footnote numbers"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/footnote.number.format.html")) t]
	      ["table.footnote.number.format - Identifies the format used for footnote numbers in tables"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.footnote.number.format.html")) t]
	      ["footnote.number.symbols -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/footnote.number.symbols.html")) t]
	      ["table.footnote.number.symbols -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/table.footnote.number.symbols.html")) t]
	      ["xref.with.number.and.title - Use number and title in cross references"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/xref.with.number.and.title.html")) t]
	      ["xref.label-page.separator - Punctuation or space separating label from page number in xref"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/xref.label-page.separator.html")) t]
	      ["xref.label-title.separator - Punctuation or space separating label from title in xref"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/xref.label-title.separator.html")) t]
	      ["xref.title-page.separator - Punctuation or space separating title from page number in xref"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/xref.title-page.separator.html")) t]
	      ["insert.xref.page.number - Turns page numbers in xrefs on and off"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/insert.xref.page.number.html")) t]
	      )
	(list "XVII. Graphics"
	      ["graphic.default.extension - Default extension for graphic filenames"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/graphic.default.extension.html")) t]
	      ["default.image.width - The default width of images"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/default.image.width.html")) t]
	      ["nominal.image.width - The nominal image width"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/nominal.image.width.html")) t]
	      ["nominal.image.depth - Nominal image depth"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/nominal.image.depth.html")) t]
	      ["use.embed.for.svg - Use HTML embed for SVG?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/use.embed.for.svg.html")) t]
	      ["make.graphic.viewport - Use tables in HTML to make viewports for graphics"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/make.graphic.viewport.html")) t]
	      ["preferred.mediaobject.role - Select which mediaobject to use based on this value of an object's role attribute."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/preferred.mediaobject.role.html")) t]
	      ["use.role.for.mediaobject - Use role attribute value for selecting which of several objects within a mediaobject to use."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/use.role.for.mediaobject.html")) t]
	      ["ignore.image.scaling - Tell the stylesheets to ignore the author's image scaling attributes"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/ignore.image.scaling.html")) t]
	      )
	(list "XVIII. Chunking"
	      ["chunker.output.cdata-section-elements - List of elements to escape with CDATA sections"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.cdata-section-elements.html")) t]
	      ["chunker.output.doctype-public - Public identifer to use in the document type of generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.doctype-public.html")) t]
	      ["chunker.output.doctype-system - System identifier to use for the document type in generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.doctype-system.html")) t]
	      ["chunker.output.encoding - Encoding used in generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.encoding.html")) t]
	      ["chunker.output.indent - Specification of indentation on generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.indent.html")) t]
	      ["chunker.output.media-type - Media type to use in generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.media-type.html")) t]
	      ["chunker.output.method - Method used in generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.method.html")) t]
	      ["chunker.output.omit-xml-declaration - Omit-xml-declaration for generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.omit-xml-declaration.html")) t]
	      ["chunker.output.standalone - Standalone declaration for generated pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunker.output.standalone.html")) t]
	      ["saxon.character.representation - Saxon character representation used in generated HTML pages"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/saxon.character.representation.html")) t]
	      ["html.ext - Identifies the extension of generated HTML files"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.ext.html")) t]
	      ["html.extra.head.links - Toggle extra HTML head link information"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/html.extra.head.links.html")) t]
	      ["root.filename - Identifies the name of the root HTML file when chunking"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/root.filename.html")) t]
	      ["base.dir - The base directory of chunks"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/base.dir.html")) t]
	      ["generate.manifest - Generate a manifest file?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/generate.manifest.html")) t]
	      ["manifest - Name of manifest file"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/manifest.html")) t]
	      ["manifest.in.base.dir - Should be manifest file written in $base.dir?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/manifest.in.base.dir.html")) t]
	      ["chunk.toc - An explicit TOC to be used for chunking"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunk.toc.html")) t]
	      ["chunk.tocs.and.lots - Should ToC and LoTs be in separate chunks?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunk.tocs.and.lots.html")) t]
	      ["chunk.section.depth - Depth to which sections should be chunked"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunk.section.depth.html")) t]
	      ["chunk.first.sections - Chunk the first top-level section?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunk.first.sections.html")) t]
	      ["chunk.quietly - Omit the chunked filename messages."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/chunk.quietly.html")) t]
	      ["navig.graphics - Use graphics in navigational headers and footers?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/navig.graphics.html")) t]
	      ["navig.graphics.extension - Extension for navigational graphics"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/navig.graphics.extension.html")) t]
	      ["navig.graphics.path - Path to navigational graphics"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/navig.graphics.path.html")) t]
	      ["navig.showtitles - Display titles in HTML headers and footers?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/navig.showtitles.html")) t]
	      )
	(list "XIX. Profiling"
	      ["profile.arch - Target profile for arch attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.arch.html")) t]
	      ["profile.condition - Target profile for condition attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.condition.html")) t]
	      ["profile.conformance - Target profile for conformance attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.conformance.html")) t]
	      ["profile.lang - Target profile for lang attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.lang.html")) t]
	      ["profile.os - Target profile for os attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.os.html")) t]
	      ["profile.revision - Target profile for revision attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.revision.html")) t]
	      ["profile.revisionflag - Target profile for revisionflag attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.revisionflag.html")) t]
	      ["profile.role - Target profile for role attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.role.html")) t]
	      ["profile.security - Target profile for security attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.security.html")) t]
	      ["profile.userlevel - Target profile for userlevel attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.userlevel.html")) t]
	      ["profile.vendor - Target profile for vendor attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.vendor.html")) t]
	      ["profile.attribute - Name of user-specified profiling attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.attribute.html")) t]
	      ["profile.value - Target profile for user-specified attribute"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.value.html")) t]
	      ["profile.separator - Separator character for compound profile values"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/profile.separator.html")) t]
	      )
	(list "XX. HTML Help"
	      ["htmlhelp.encoding - Character encoding to use in files for HTML Help compiler."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.encoding.html")) t]
	      ["htmlhelp.autolabel - Should tree-like ToC use autonumbering feature?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.autolabel.html")) t]
	      ["htmlhelp.chm - Filename of output HTML Help file."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.chm.html")) t]
	      ["htmlhelp.default.topic - Name of file with default topic"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.default.topic.html")) t]
	      ["htmlhelp.hhp - Filename of project file."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhp.html")) t]
	      ["htmlhelp.hhc - Filename of TOC file."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhc.html")) t]
	      ["htmlhelp.hhk - Filename of index file."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhk.html")) t]
	      ["htmlhelp.hhp.tail - Additional content for project file."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhp.tail.html")) t]
	      ["htmlhelp.hhp.window - Name of default window."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhp.window.html")) t]
	      ["htmlhelp.enumerate.images - Should be paths to all used images added to project file?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.enumerate.images.html")) t]
	      ["htmlhelp.force.map.and.alias - Should be [MAP] and [ALIAS] section added to project file unconditionaly?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.force.map.and.alias.html")) t]
	      ["htmlhelp.map.file - Filename of map file."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.map.file.html")) t]
	      ["htmlhelp.alias.file - Filename of map file."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.alias.file.html")) t]
	      ["htmlhelp.hhc.section.depth - Depth of TOC for sections in a left pane."
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhc.section.depth.html")) t]
	      ["htmlhelp.hhc.show.root - Should be entry for root element shown in ToC?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhc.show.root.html")) t]
	      ["htmlhelp.hhc.folders.instead.books -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhc.folders.instead.books.html")) t]
	      ["htmlhelp.hhc.binary -"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.hhc.binary.html")) t]
	      ["htmlhelp.title - Title of HTML Help"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.title.html")) t]
	      ["htmlhelp.show.menu - Should be menu shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.show.menu.html")) t]
	      ["htmlhelp.show.advanced.search - Should be advanced search available?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.show.advanced.search.html")) t]
	      ["htmlhelp.show.favorities - Should be favorities tab shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.show.favorities.html")) t]
	      ["htmlhelp.button.hideshow - Should be Hide/Show button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.hideshow.html")) t]
	      ["htmlhelp.button.back - Should be Back button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.back.html")) t]
	      ["htmlhelp.button.forward - Should be Forward button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.forward.html")) t]
	      ["htmlhelp.button.stop - Should be Stop button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.stop.html")) t]
	      ["htmlhelp.button.refresh - Should be Refresh button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.refresh.html")) t]
	      ["htmlhelp.button.home - Should be Home button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.home.html")) t]
	      ["htmlhelp.button.home.url - URL address of page accessible by Home button"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.home.url.html")) t]
	      ["htmlhelp.button.options - Should be Options button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.options.html")) t]
	      ["htmlhelp.button.print - Should be Print button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.print.html")) t]
	      ["htmlhelp.button.locate - Should be Locate button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.locate.html")) t]
	      ["htmlhelp.button.jump1 - Should be Jump1 button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.jump1.html")) t]
	      ["htmlhelp.button.jump1.url - URL address of page accessible by Jump1 button"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.jump1.url.html")) t]
	      ["htmlhelp.button.jump1.title - Title of Jump1 button"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.jump1.title.html")) t]
	      ["htmlhelp.button.jump2 - Should be Jump2 button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.jump2.html")) t]
	      ["htmlhelp.button.jump2.url - URL address of page accessible by Jump2 button"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.jump2.url.html")) t]
	      ["htmlhelp.button.jump2.title - Title of Jump2 button"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.jump2.title.html")) t]
	      ["htmlhelp.button.next - Should be Next button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.next.html")) t]
	      ["htmlhelp.button.prev - Should be Prev button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.prev.html")) t]
	      ["htmlhelp.button.zoom - Should be Zoom button shown?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.button.zoom.html")) t]
	      ["htmlhelp.use.hhk - Should be index built using HHK file?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.use.hhk.html")) t]
	      ["htmlhelp.only - Should be only project files generated?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/htmlhelp.only.html")) t]
	      )
	(list "XXI. Eclipse Help Platform"
	      ["eclipse.autolabel - Should tree-like ToC use autonumbering feature?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/eclipse.autolabel.html")) t]
	      ["eclipse.plugin.name - Eclipse Help plugin name"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/eclipse.plugin.name.html")) t]
	      ["eclipse.plugin.id - Eclipse Help plugin id"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/eclipse.plugin.id.html")) t]
	      ["eclipse.plugin.provider - Eclipse Help plugin provider name"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/eclipse.plugin.provider.html")) t]
	      )
	(list "XXII. Localization"
	      ["l10n.gentext.language - Sets the gentext language"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/l10n.gentext.language.html")) t]
	      ["l10n.gentext.default.language - Sets the default language for generated text"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/l10n.gentext.default.language.html")) t]
	      ["l10n.gentext.use.xref.language - Use the language of target when generating cross-reference text?"
	       (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/html/l10n.gentext.use.xref.language.html")) t]
	      )
	)
  "XSLT stylesheet FO parameters submenu for 'docbook-menu'."
  )
