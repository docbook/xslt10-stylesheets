;;; dbk-xslfo.el --- List of DocBook XSLT FO parameters
;; for DocBook XSLT stylesheets version 1.64.0
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$

(defvar docbook-menu-xsl-params-fo
      (list "DocBook XSL: Parameter Reference - FO"
	    (list "I. Admonitions"
		  ["admon.graphics - Use graphics in admonitions?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/admon.graphics.html")) t]
		  ["admon.graphics.extension - Extension for admonition graphics"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/admon.graphics.extension.html")) t]
		  ["admon.graphics.path - Path to admonition graphics"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/admon.graphics.path.html")) t]
		  ["admon.textlabel - Use text label in admonitions?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/admon.textlabel.html")) t]
		  ["admonition.title.properties - To set the style for admonitions titles."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/admonition.title.properties.html")) t]
		  ["admonition.properties - To set the style for admonitions."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/admonition.properties.html")) t]
		  )
	    (list "II. Callouts"
		  ["callout.defaultcolumn - Indicates what column callouts appear in by default"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.defaultcolumn.html")) t]
		  ["callout.graphics - Use graphics for callouts?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.graphics.html")) t]
		  ["callout.graphics.extension - Extension for callout graphics"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.graphics.extension.html")) t]
		  ["callout.graphics.number.limit - Number of the largest callout graphic"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.graphics.number.limit.html")) t]
		  ["callout.graphics.path - Path to callout graphics"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.graphics.path.html")) t]
		  ["callout.unicode - Use Unicode characters rather than images for callouts."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.unicode.html")) t]
		  ["callout.unicode.font - Specify a font for Unicode glyphs"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.unicode.font.html")) t]
		  ["callout.unicode.number.limit - Number of the largest callout graphic"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.unicode.number.limit.html")) t]
		  ["callout.unicode.start.character - First Unicode character to use, decimal value."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callout.unicode.start.character.html")) t]
		  ["callouts.extension - Enable the callout extension"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/callouts.extension.html")) t]
		  )
	    (list "III. ToC/LoT/Index Generation"
		  ["autotoc.label.separator - Separator between labels and titles in the ToC"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/autotoc.label.separator.html")) t]
		  ["process.empty.source.toc - FIXME:"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/process.empty.source.toc.html")) t]
		  ["process.source.toc - FIXME:"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/process.source.toc.html")) t]
		  ["generate.toc - Control generation of ToCs and LoTs"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/generate.toc.html")) t]
		  ["generate.index - Do you want an index?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/generate.index.html")) t]
		  ["make.index.markup - Generate XML index markup in the index?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/make.index.markup.html")) t]
		  ["xep.index.item.properties - Properties associated with XEP index-items"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/xep.index.item.properties.html")) t]
		  ["toc.section.depth - How deep should recursive sections appear in the TOC?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/toc.section.depth.html")) t]
		  ["toc.indent.width - Amount of indentation for TOC entries"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/toc.indent.width.html")) t]
		  ["toc.margin.properties - Margin properties used on Tables of Contents"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/toc.margin.properties.html")) t]
		  ["bridgehead.in.toc - Should bridgehead elements appear in the TOC?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/bridgehead.in.toc.html")) t]
		  ["generate.section.toc.level - Control depth of TOC generation in sections"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/generate.section.toc.level.html")) t]
		  )
	    (list "IV. Processor Extensions"
		  ["arbortext.extensions - Enable Arbortext extensions?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/arbortext.extensions.html")) t]
		  ["axf.extensions - Enable XSL Formatter extensions?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/axf.extensions.html")) t]
		  ["fop.extensions - Enable FOP extensions?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/fop.extensions.html")) t]
		  ["passivetex.extensions - Enable PassiveTeX extensions?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/passivetex.extensions.html")) t]
		  ["tex.math.in.alt - TeX notation used for equations"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/tex.math.in.alt.html")) t]
		  ["tex.math.delims - Should be equations outputed for processing by TeX automatically surrounded by math mode delimiters"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/tex.math.delims.html")) t]
		  ["xep.extensions - Enable XEP extensions?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/xep.extensions.html")) t]
		  )
	    (list "V. Stylesheet Extensions"
		  ["linenumbering.everyNth - Indicate which lines should be numbered"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/linenumbering.everyNth.html")) t]
		  ["linenumbering.extension - Enable the line numbering extension"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/linenumbering.extension.html")) t]
		  ["linenumbering.separator - Specify a separator between line numbers and lines"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/linenumbering.separator.html")) t]
		  ["linenumbering.width - Indicates the width of line numbers"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/linenumbering.width.html")) t]
		  ["tablecolumns.extension - Enable the table columns extension function"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/tablecolumns.extension.html")) t]
		  ["textinsert.extension - Enable the textinsert extension element"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/textinsert.extension.html")) t]
		  ["use.extensions - Enable extensions"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/use.extensions.html")) t]
		  )
	    (list "VI. Automatic labelling"
		  ["appendix.autolabel - Are Appendixes automatically enumerated?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/appendix.autolabel.html")) t]
		  ["chapter.autolabel - Are chapters automatically enumerated?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/chapter.autolabel.html")) t]
		  ["part.autolabel - Are parts and references enumerated?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/part.autolabel.html")) t]
		  ["preface.autolabel - Are prefaces enumerated?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/preface.autolabel.html")) t]
		  ["section.autolabel - Are sections enumerated?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.autolabel.html")) t]
		  ["section.label.includes.component.label - Do section labels include the component label?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.label.includes.component.label.html")) t]
		  ["label.from.part - Renumber chapters in each part?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/label.from.part.html")) t]
		  )
	    (list "VII. XSLT Processing"
		  ["rootid - Specify the root element to format"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/rootid.html")) t]
		  )
	    (list "VIII. Meta/*Info"
		  ["make.single.year.ranges - Print single-year ranges (e.g., 1998-1999)"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/make.single.year.ranges.html")) t]
		  ["make.year.ranges - Collate copyright years into ranges?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/make.year.ranges.html")) t]
		  ["author.othername.in.middle - Is othername in author a middle name?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/author.othername.in.middle.html")) t]
		  )
	    (list "IX. Reference Pages"
		  ["funcsynopsis.decoration - Decorate elements of a FuncSynopsis?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/funcsynopsis.decoration.html")) t]
		  ["funcsynopsis.style - What style of 'FuncSynopsis' should be generated?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/funcsynopsis.style.html")) t]
		  ["function.parens - Generate parens after a function?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/function.parens.html")) t]
		  ["refentry.generate.name - Output NAME header before 'RefName'(s)?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/refentry.generate.name.html")) t]
		  ["refentry.generate.title - Output title before 'RefName'(s)?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/refentry.generate.title.html")) t]
		  ["refentry.title.properties - Title properties for a refentry title"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/refentry.title.properties.html")) t]
		  ["refentry.xref.manvolnum - Output manvolnum as part of refentry cross-reference?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/refentry.xref.manvolnum.html")) t]
		  )
	    (list "X. Tables"
		  ["default.table.width - The default width of tables"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/default.table.width.html")) t]
		  ["nominal.table.width - The (absolute) nominal width of tables"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/nominal.table.width.html")) t]
		  ["table.cell.padding -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.cell.padding.html")) t]
		  ["table.frame.border.thickness - Specifies the thickness of the frame border"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.frame.border.thickness.html")) t]
		  ["table.frame.border.style -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.frame.border.style.html")) t]
		  ["table.frame.border.color -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.frame.border.color.html")) t]
		  ["table.cell.border.thickness -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.cell.border.thickness.html")) t]
		  ["table.cell.border.style -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.cell.border.style.html")) t]
		  ["table.cell.border.color -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.cell.border.color.html")) t]
		  )
	    (list "XI. Linking"
		  ["target.database.document - Name of master database file for resolving olinks"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/target.database.document.html")) t]
		  ["use.local.olink.style - Process olinks using xref style of current document"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/use.local.olink.style.html")) t]
		  ["current.docid - targetdoc identifier for the document being processed"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/current.docid.html")) t]
		  ["olink.doctitle - show the document title for external olinks?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/olink.doctitle.html")) t]
		  )
	    (list "XII. QAndASet"
		  ["qandadiv.autolabel - Are divisions in QAndASets enumerated?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qandadiv.autolabel.html")) t]
		  ["qanda.inherit.numeration - Does enumeration of QandASet components inherit the numeration of parent elements?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.inherit.numeration.html")) t]
		  ["qanda.defaultlabel - Sets the default for defaultlabel on QandASet."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.defaultlabel.html")) t]
		  )
	    (list "XIII. Bibliography"
		  ["biblioentry.item.separator - Text to separate bibliography entries"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/biblioentry.item.separator.html")) t]
		  ["bibliography.collection - Name of the bibliography collection file"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/bibliography.collection.html")) t]
		  ["bibliography.numbered - Should bibliography entries be numbered?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/bibliography.numbered.html")) t]
		  )
	    (list "XIV. Glossary"
		  ["glossterm.auto.link - Generate links from glossterm to glossentry automaticaly?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/glossterm.auto.link.html")) t]
		  ["firstterm.only.link - Does automatic glossterm linking only apply to firstterms?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/firstterm.only.link.html")) t]
		  ["glossary.collection - Name of the glossary collection file"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/glossary.collection.html")) t]
		  ["glossterm.separation - Separation between glossary terms and descriptions in list mode"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/glossterm.separation.html")) t]
		  ["glossterm.width - Width of glossterm in list presentation mode"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/glossterm.width.html")) t]
		  ["glossary.as.blocks - Present glossarys using blocks instead of lists?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/glossary.as.blocks.html")) t]
		  ["glosslist.as.blocks - Use blocks for glosslists?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/glosslist.as.blocks.html")) t]
		  ["glossentry.show.acronym - Display glossentry acronyms?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/glossentry.show.acronym.html")) t]
		  )
	    (list "XV. Miscellaneous"
		  ["formal.procedures - Selects formal or informal procedures"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/formal.procedures.html")) t]
		  ["formal.title.placement -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/formal.title.placement.html")) t]
		  ["runinhead.default.title.end.punct - Default punctuation character on a run-in-head"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/runinhead.default.title.end.punct.html")) t]
		  ["runinhead.title.end.punct - Characters that count as punctuation on a run-in-head"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/runinhead.title.end.punct.html")) t]
		  ["show.comments - Display comment elements?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/show.comments.html")) t]
		  ["punct.honorific - Punctuation after an honorific in a personal name."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/punct.honorific.html")) t]
		  ["segmentedlist.as.table - Format segmented lists as tables?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/segmentedlist.as.table.html")) t]
		  ["variablelist.as.blocks - Format variablelists lists as blocks?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/variablelist.as.blocks.html")) t]
		  ["blockquote.properties - To set the style for block quotations."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/blockquote.properties.html")) t]
		  ["ulink.show - Display URLs after ulinks?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/ulink.show.html")) t]
		  ["ulink.footnotes - Generate footnotes for ULinks?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/ulink.footnotes.html")) t]
		  ["ulink.footnote.number.format - Identifies the format used for ulink footnote numbers"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/ulink.footnote.number.format.html")) t]
		  ["ulink.hyphenate - Allow URLs to be automatically hyphenated"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/ulink.hyphenate.html")) t]
		  ["shade.verbatim - Should verbatim environments be shaded?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/shade.verbatim.html")) t]
		  ["shade.verbatim.style - Properties that specify the style of shaded verbatim listings"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/shade.verbatim.style.html")) t]
		  ["use.svg - Allow SVG in the result tree?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/use.svg.html")) t]
		  ["use.role.as.xrefstyle - Use role attribute for xrefstyle on xref?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/use.role.as.xrefstyle.html")) t]
		  ["menuchoice.separator -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/menuchoice.separator.html")) t]
		  ["menuchoice.menu.separator -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/menuchoice.menu.separator.html")) t]
		  ["default.float.class - Specifies the default float class"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/default.float.class.html")) t]
		  ["footnote.number.format - Identifies the format used for footnote numbers"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/footnote.number.format.html")) t]
		  ["table.footnote.number.format - Identifies the format used for footnote numbers in tables"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.footnote.number.format.html")) t]
		  ["footnote.number.symbols -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/footnote.number.symbols.html")) t]
		  ["table.footnote.number.symbols -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.footnote.number.symbols.html")) t]
		  ["xref.with.number.and.title - Use number and title in cross references"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/xref.with.number.and.title.html")) t]
		  )
	    (list "XVI. Graphics"
		  ["graphic.default.extension - Default extension for graphic filenames"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/graphic.default.extension.html")) t]
		  ["default.image.width - The default width of images"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/default.image.width.html")) t]
		  ["preferred.mediaobject.role - Select which mediaobject to use based on this value of an object's role attribute."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/preferred.mediaobject.role.html")) t]
		  ["use.role.for.mediaobject - Use role attribute value for selecting which of several objects within a mediaobject to use."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/use.role.for.mediaobject.html")) t]
		  ["ignore.image.scaling - Tell the stylesheets to ignore the author's image scaling attributes"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/ignore.image.scaling.html")) t]
		  )
	    (list "XVII. Pagination and General Styles"
		  ["page.height - The height of the physical page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.height.html")) t]
		  ["page.height.portrait - Specify the physical size of the long edge of the page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.height.portrait.html")) t]
		  ["page.margin.bottom - The bottom margin of the page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.margin.bottom.html")) t]
		  ["page.margin.inner - The inner page margin"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.margin.inner.html")) t]
		  ["page.margin.outer - The outer page margin"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.margin.outer.html")) t]
		  ["page.margin.top - The top margin of the page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.margin.top.html")) t]
		  ["page.orientation - Select the page orientation"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.orientation.html")) t]
		  ["page.width - The width of the physical page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.width.html")) t]
		  ["page.width.portrait - Specify the physical size of the short edge of the page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/page.width.portrait.html")) t]
		  ["paper.type - Select the paper type"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/paper.type.html")) t]
		  ["double.sided - Is the document to be printed double sided?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/double.sided.html")) t]
		  ["body.margin.bottom - The bottom margin of the body text"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/body.margin.bottom.html")) t]
		  ["body.margin.top - To specify the size of the top margin of a page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/body.margin.top.html")) t]
		  ["alignment - Specify the default text alignment"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/alignment.html")) t]
		  ["hyphenate - Specify hyphenation behavior"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/hyphenate.html")) t]
		  ["line-height - Specify the line-height property"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/line-height.html")) t]
		  ["column.count.back - Number of columns on back matter pages"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.count.back.html")) t]
		  ["column.count.body - Number of columns on body pages"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.count.body.html")) t]
		  ["column.count.front - Number of columns on front matter pages"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.count.front.html")) t]
		  ["column.count.index - Number of columns on index pages"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.count.index.html")) t]
		  ["column.count.lot - Number of columns on a 'List-of-Titles' page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.count.lot.html")) t]
		  ["column.count.titlepage - Number of columns on a title page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.count.titlepage.html")) t]
		  ["column.gap.back - Gap between columns in back matter"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.gap.back.html")) t]
		  ["column.gap.body - Gap between columns in the body"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.gap.body.html")) t]
		  ["column.gap.front - Gap between columns in the front matter"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.gap.front.html")) t]
		  ["column.gap.index - Gap between columns in the index"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.gap.index.html")) t]
		  ["column.gap.lot - Gap between columns on a 'List-of-Titles' page"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.gap.lot.html")) t]
		  ["column.gap.titlepage - Gap between columns on title pages"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/column.gap.titlepage.html")) t]
		  ["region.after.extent - Specifies the height of the footer."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/region.after.extent.html")) t]
		  ["region.before.extent - Specifies the height of the header"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/region.before.extent.html")) t]
		  ["default.units - Default units for an unqualified dimension"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/default.units.html")) t]
		  ["normal.para.spacing - What space do you want between normal paragraphs"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/normal.para.spacing.html")) t]
		  ["body.font.master - Specifies the default point size for body text"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/body.font.master.html")) t]
		  ["body.font.size - Specifies the default font size for body text"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/body.font.size.html")) t]
		  ["footnote.font.size - The font size for footnotes"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/footnote.font.size.html")) t]
		  ["title.margin.left - Adjust the left margin for titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/title.margin.left.html")) t]
		  ["draft.mode - Select draft mode"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/draft.mode.html")) t]
		  ["draft.watermark.image - The URI of the image to be used for draft watermarks"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/draft.watermark.image.html")) t]
		  ["headers.on.blank.pages - Put headers on blank pages?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/headers.on.blank.pages.html")) t]
		  ["footers.on.blank.pages - Put footers on blank pages?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/footers.on.blank.pages.html")) t]
		  ["header.rule - Rule under headers?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/header.rule.html")) t]
		  ["footer.rule - Rule over footers?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/footer.rule.html")) t]
		  ["header.content.properties -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/header.content.properties.html")) t]
		  ["footer.content.properties -"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/footer.content.properties.html")) t]
		  )
	    (list "XVIII. Font Families"
		  ["body.font.family - The default font family for body text"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/body.font.family.html")) t]
		  ["dingbat.font.family - The font family for copyright, quotes, and other symbols"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/dingbat.font.family.html")) t]
		  ["monospace.font.family - The default font family for monospace environments"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/monospace.font.family.html")) t]
		  ["sans.font.family - The default sans-serif font family"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/sans.font.family.html")) t]
		  ["title.font.family - The default font family for titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/title.font.family.html")) t]
		  ["symbol.font.family - The font families to be searched for symbols outside of the body font"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/symbol.font.family.html")) t]
		  )
	    (list "XIX. Lists"
		  ["list.block.spacing - What spacing do you want before and after lists?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/list.block.spacing.html")) t]
		  ["list.item.spacing - What space do you want between list items?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/list.item.spacing.html")) t]
		  ["compact.list.item.spacing - What space do you want between list items (when spacing=compact)?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/compact.list.item.spacing.html")) t]
		  ["variablelist.max.termlength - Specifies the longest term in variablelists"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/variablelist.max.termlength.html")) t]
		  )
	    (list "XX. Cross References"
		  ["insert.xref.page.number - Turns page numbers in xrefs on and off"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/insert.xref.page.number.html")) t]
		  ["xref.properties - Properties associated with cross-reference text"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/xref.properties.html")) t]
		  ["xref.label-title.separator - Punctuation or space separating label from title in xref"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/xref.label-title.separator.html")) t]
		  ["xref.label-page.separator - Punctuation or space separating label from page number in xref"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/xref.label-page.separator.html")) t]
		  ["xref.title-page.separator - Punctuation or space separating title from page number in xref"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/xref.title-page.separator.html")) t]
		  )
	    (list "XXI. Property Sets"
		  ["formal.object.properties - Properties associated with a formal object such as a figure, or other component that has a title"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/formal.object.properties.html")) t]
		  ["formal.title.properties - Style the title element of formal object such as a figure."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/formal.title.properties.html")) t]
		  ["informal.object.properties - Properties associated with a formal object such as a figure, or other component that has a title"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/informal.object.properties.html")) t]
		  ["monospace.properties - Properties of monospaced content"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/monospace.properties.html")) t]
		  ["verbatim.properties - Properties associated with verbatim text"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/verbatim.properties.html")) t]
		  ["monospace.verbatim.properties - What font and size do you want for monospaced content?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/monospace.verbatim.properties.html")) t]
		  ["sidebar.properties - Attribute set for sidebar properties"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/sidebar.properties.html")) t]
		  ["section.title.properties - Properties for section titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.title.properties.html")) t]
		  ["section.title.level1.properties - Properties for level-1 section titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.title.level1.properties.html")) t]
		  ["section.title.level2.properties - Properties for level-1 section titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.title.level2.properties.html")) t]
		  ["section.title.level3.properties - Properties for level-1 section titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.title.level3.properties.html")) t]
		  ["section.title.level4.properties - Properties for level-1 section titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.title.level4.properties.html")) t]
		  ["section.title.level5.properties - Properties for level-1 section titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.title.level5.properties.html")) t]
		  ["section.title.level6.properties - Properties for level-1 section titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.title.level6.properties.html")) t]
		  ["section.properties - Properties for all section levels"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.properties.html")) t]
		  ["section.level1.properties - Properties for level-1 sections"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.level1.properties.html")) t]
		  ["section.level2.properties - Properties for level-2 sections"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.level2.properties.html")) t]
		  ["section.level3.properties - Properties for level-3 sections"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.level3.properties.html")) t]
		  ["section.level4.properties - Properties for level-4 sections"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.level4.properties.html")) t]
		  ["section.level5.properties - Properties for level-5 sections"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.level5.properties.html")) t]
		  ["section.level6.properties - Properties for level-6 sections"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/section.level6.properties.html")) t]
		  ["figure.properties - Properties associated with a figure"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/figure.properties.html")) t]
		  ["example.properties - Properties associated with a example"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/example.properties.html")) t]
		  ["equation.properties - Properties associated with a equation"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/equation.properties.html")) t]
		  ["table.properties - Properties associated with a table"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/table.properties.html")) t]
		  ["procedure.properties - Properties associated with a procedure"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/procedure.properties.html")) t]
		  ["root.properties - The properties of the fo:root element"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/root.properties.html")) t]
		  ["qanda.title.properties - Properties for qanda set titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.title.properties.html")) t]
		  ["qanda.title.level1.properties - Properties for level-1 qanda set titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.title.level1.properties.html")) t]
		  ["qanda.title.level2.properties - Properties for level-2 qanda set titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.title.level2.properties.html")) t]
		  ["qanda.title.level3.properties - Properties for level-3 qanda set titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.title.level3.properties.html")) t]
		  ["qanda.title.level4.properties - Properties for level-4 qanda set titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.title.level4.properties.html")) t]
		  ["qanda.title.level5.properties - Properties for level-5 qanda set titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.title.level5.properties.html")) t]
		  ["qanda.title.level6.properties - Properties for level-6 qanda set titles"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/qanda.title.level6.properties.html")) t]
		  )
	    (list "XXII. Profiling"
		  ["profile.arch - Target profile for arch attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.arch.html")) t]
		  ["profile.condition - Target profile for condition attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.condition.html")) t]
		  ["profile.conformance - Target profile for conformance attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.conformance.html")) t]
		  ["profile.lang - Target profile for lang attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.lang.html")) t]
		  ["profile.os - Target profile for os attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.os.html")) t]
		  ["profile.revision - Target profile for revision attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.revision.html")) t]
		  ["profile.revisionflag - Target profile for revisionflag attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.revisionflag.html")) t]
		  ["profile.role - Target profile for role attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.role.html")) t]
		  ["profile.security - Target profile for security attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.security.html")) t]
		  ["profile.userlevel - Target profile for userlevel attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.userlevel.html")) t]
		  ["profile.vendor - Target profile for vendor attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.vendor.html")) t]
		  ["profile.attribute - Name of user-specified profiling attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.attribute.html")) t]
		  ["profile.value - Target profile for user-specified attribute"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.value.html")) t]
		  ["profile.separator - Separator character for compound profile values"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/profile.separator.html")) t]
		  )
	    (list "XXIII. Localization"
		  ["l10n.gentext.language - Sets the gentext language"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/l10n.gentext.language.html")) t]
		  ["l10n.gentext.default.language - Sets the default language for generated text"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/l10n.gentext.default.language.html")) t]
		  ["l10n.gentext.use.xref.language - Use the language of target when generating cross-reference text?"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/l10n.gentext.use.xref.language.html")) t]
		  )
	    (list "XXIV. EBNF"
		  ["ebnf.assignment - The EBNF production assignment operator"
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/ebnf.assignment.html")) t]
		  ["ebnf.statement.terminator - Punctuation that ends an EBNF statement."
		   (browse-url (concat "file:///" docbook-menu-xsl-docs-dir "/doc/fo/ebnf.statement.terminator.html")) t]
		  )
	    )
      "XSLT stylesheet FO parameters submenu for 'docbook-menu'."
      )
