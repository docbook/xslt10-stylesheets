;;; dbk-xsltcg.el --- List of DocBook:XSL TCG chapters
;; for the second edition
;; Revision: $Revision$
;; Date: $Date$
;; RCS Id: $Id$

(defvar docbook-menu-xsl-tcg
  (list "DocBook XSL: The Complete Guide"
	["Buy the Paperback"
	 (browse-url "http://www.amazon.com/exec/obidos/ASIN/0974152110/") t]
	["Buy the E-Book"
	 (browse-url "http://www.sagehill.net/book-purchase.html") t]
	["--" t]
	(list "Preface"
	      ["What is DocBook?"
	       (browse-url (concat docbook-menu-xsl-tcg-uri "/preface.html#WhatIsDocbook")) t]
	      ["Audience"
	       (browse-url (concat docbook-menu-xsl-tcg-uri "/Audience.html")) t]
	      ["Changes in the Second Edition"
	       (browse-url (concat docbook-menu-xsl-tcg-uri "/ChangesSecondEd.html")) t]
	      ["Acknowledgements"
	       (browse-url (concat docbook-menu-xsl-tcg-uri "/Acknowledgement.html")) t]
	      )
	(list "Part I. Setting up the tools"
	      (list "Chapter 1. Introduction"
		    ["How this book is organized"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/intro.html#HowOrganized")) t]
		    ["Online resources for finding solutions to problems"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/OnlineResources.html")) t]
		    )
	      (list "Chapter 2. XSL processors"
		    ["XSLT processors"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/XSLprocessors.html#XSLTprocessors")) t]
		    ["XSL-FO processors"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/FOprocessors.html")) t]
		    ["Portability considerations"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Portability.html")) t]
		    )
	      (list "Chapter 3. Getting the tools working"
		    ["Installing the DocBook DTD"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ToolsSetup.html#InstallDTD")) t]
		    ["Installing the DocBook stylesheets"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/InstallStylesheets.html")) t]
		    ["Installing an XSLT processor"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/InstallingAProcessor.html")) t]
		    ["Installing an XSL-FO processor"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/InstallingAnFO.html")) t]
		    ["Makefiles"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Makefiles.html")) t]
		    )
	      (list "Chapter 4. XML catalogs"
		    ["Why use XML catalogs"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Catalogs.html#WhyCatalogs")) t]
		    ["How to write an XML catalog file"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/WriteCatalog.html")) t]
		    ["Example DocBook catalog file"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ExampleCatalog.html")) t]
		    ["How to use a catalog file"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/UseCatalog.html")) t]
		    )
	      )
	(list "Part II. Stylesheet options"
	      (list "Chapter 5. Using stylesheet parameters"
		    ["Parameters on the command line"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Parameters.html#ParameterSyntax")) t]
		    ["Parameters in a file"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ParametersInFile.html")) t]
		    )
	      (list "Chapter 6. HTML output options"
		    ["Single HTML file"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/HtmlOutput.html#SingleHtml")) t]
		    ["Processing part of a document"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Rootid.html")) t]
		    ["Chunking into multiple HTML files"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Chunking.html")) t]
		    ["Using CSS to style HTML"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/UsingCSS.html")) t]
		    ["Chapter and section numbering"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/SectionNumbering.html")) t]
		    ["Docbook icon graphics"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Icons.html")) t]
		    ["List variations"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ListVariations.html")) t]
		    ["Date and time"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Datetime.html")) t]
		    )
	      (list "Chapter 7. Printed output options"
		    ["Page layout"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PrintOutput.html#PageLayout")) t]
		    ["Typography"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Typography.html")) t]
		    ["Chapter and section numbering"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/FOSectionNumbering.html")) t]
		    ["PDF bookmarks"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PdfBookmarks.html")) t]
		    ["Variable list formatting"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ListIndents.html")) t]
		    ["Extra blank lines"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/BlankLines.html")) t]
		    ["Cross reference page numbers"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/XrefPageNums.html")) t]
		    ["Docbook icon graphics"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PrintIcons.html")) t]
		    ["Printing one chapter"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PrintOneChapter.html")) t]
		    )
	      )
	(list "Part III. Customizing DocBook XSL"
	      (list "Chapter 8. Customization methods"
		    ["Customization layer"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CustomMethods.html#CustomizationLayer")) t]
		    ["Setting parameters"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/SettingParams.html")) t]
		    ["Attribute sets"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/AttributeSets.html")) t]
		    ["Completing placeholder templates"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/EmptyTemplates.html")) t]
		    ["Generating new templates"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/GenTemplates.html")) t]
		    ["Generated text"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CustomGentext.html")) t]
		    ["Replacing templates"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ReplaceTemplate.html")) t]
		    )
	      (list "Chapter 9. General customizations"
		    ["Custom section numbering"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/GeneralCustoms.html#SectionNum")) t]
		    ["Tables of contents (TOC)"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/TOCcontrol.html")) t]
		    ["Figure, table, and other titles"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/FormalTitles.html")) t]
		    )
	      (list "Chapter 10. HTML customizations"
		    ["HTML title page customization"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/HtmlCustomEx.html#HTMLTitlePage")) t]
		    ["HTML headers and footers"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/HTMLHeaders.html")) t]
		    ["HTML HEAD elements"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/HtmlHead.html")) t]
		    ["BODY attributes"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/BodyAtts.html")) t]
		    ["HTML frameset"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/HtmlFrames.html")) t]
		    ["Chunking customization"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ChunkingCustomization.html")) t]
		    )
	      (list "Chapter 11. Print customizations"
		    ["Document level properties"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PrintCustomEx.html#RootProperties")) t]
		    ["Title fonts and sizes"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/TitleFontSizes.html")) t]
		    ["Custom page design"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PageDesign.html")) t]
		    ["Print title pages"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/TitlePagePrint.html")) t]
		    ["Section title pages"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/SectionTitlePages.html")) t]
		    ["Print TOC control"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PrintToc.html")) t]
		    ["Running headers and footers"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/PrintHeaders.html")) t]
		    ["Customizing inline text"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CustomInlines.html")) t]
		    ["Adding a font"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/AddFont.html")) t]
		    )
	      )
	(list "Part IV. Special DocBook features"
	      (list "Chapter 12. Bibliographies"
		    ["Bibliography entries"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Bibliographies.html#BiblioElements")) t]
		    ["Bibliography database"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/BiblioDatabase.html")) t]
		    ["Citing bibliographic entries"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CiteBiblio.html")) t]
		    ["Numbered bibliography entries"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/NumberedBiblio.html")) t]
		    ["Customizing bibliography output"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CustomBiblio.html")) t]
		    )
	      (list "Chapter 13. Cross references"
		    ["Cross references within a document"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CrossRefs.html#IdrefLinks")) t]
		    ["Cross references between documents"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Olinks.html")) t]
		    ["Linking to websites"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Ulinks.html")) t]
		    ["Customizing cross references"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CustomXrefs.html")) t]
		    ["Specialized cross references"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/SpecialXrefs.html")) t]
		    )
	      (list "Chapter 14. Glossaries"
		    ["Glossary formatting"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Glossaries.html#GlossaryFormat")) t]
		    ["Linking to a glossary entry"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/LinkToGlossary.html")) t]
		    ["Glossary database"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/GlossDatabase.html")) t]
		    )
	      (list "Chapter 15. Graphics"
		    ["Selecting file formats"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Graphics.html#GraphicFormats")) t]
		    ["Stylesheet's selection process"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/GraphicSelection.html")) t]
		    ["Image sizing"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ImageSizing.html")) t]
		    ["Image alignment"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ImageAlignment.html")) t]
		    ["Background color"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/BGcolor.html")) t]
		    ["Captions"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Captions.html")) t]
		    ["Alt text"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/AltText.html")) t]
		    ["Long descriptions"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/LongDescripts.html")) t]
		    ["Graphics locations"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/GraphicsLocations.html")) t]
		    ["SVG images"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/SVGimages.html")) t]
		    )
	      (list "Chapter 16. Indexes"
		    ["Adding indexterms"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/GenerateIndex.html#Indexterms")) t]
		    ["Outputting an index"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/IndexOutput.html")) t]
		    ["Cleaning up an FO index"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/IndexCleanup.html")) t]
		    )
	      (list "Chapter 17. Languages, characters and encoding"
		    ["Document encoding"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CharEncoding.html#DocumentEncoding")) t]
		    ["Output encoding"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/OutputEncoding.html")) t]
		    ["Special characters"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/SpecialChars.html")) t]
		    ["Language support"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Localizations.html")) t]
		    )
	      (list "Chapter 18. Math"
		    ["Plain text math"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Math.html#TextMath")) t]
		    ["Graphic math"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/BlockEqn.html")) t]
		    ["SVG math"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/SVGmath.html")) t]
		    ["DBTeXMath"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/TexMath.html")) t]
		    ["MathML"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/MathML.html")) t]
		    )
	      (list "Chapter 19. Modular DocBook files"
		    ["Using XInclude"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ModularDoc.html#UsingXinclude")) t]
		    ["Validating with XIncludes"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ValidXinclude.html")) t]
		    ["Modular cross referencing"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/modular-olinks.html")) t]
		    ["Modular sections"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ModularSections.html")) t]
		    ["Shared text entities"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ModularEntities.html")) t]
		    ["Processing your modular documents"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Xinclude.html")) t]
		    ["Using a module more than once in the same document"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/DuplicateIDs.html")) t]
		    )
	      (list "Chapter 20. Olinking between documents"
		    ["How to link between documents"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Olinking.html#LinkBetweenDocs")) t]
		    ["Details to watch out for"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/OlinkDetails.html")) t]
		    ["Useful variations"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/OlinkVariations.html")) t]
		    ["Target database additional uses"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/TargetsetUses.html")) t]
		    )
	      (list "Chapter 21. Other output forms"
		    ["XHTML"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/OtherOutputForms.html#Xhtml")) t]
		    ["HTML Help"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/HtmlHelp.html")) t]
		    ["JavaHelp"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/JavaHelp.html")) t]
		    ["Refentry to man"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/RefentryToMan.html")) t]
		    )
	      (list "Chapter 22. Profiling (conditional text)"
		    ["Marking conditional text"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Profiling.html#MarkProfileText")) t]
		    ["Marking small bits of text"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/MarkTextBits.html")) t]
		    ["Multiple profiling conditions"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/MultiProfile.html")) t]
		    ["Processing profiled versions"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/AlternateText.html")) t]
		    ["Customization and profiling"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ProfileCustom.html")) t]
		    ["Validation and profiling"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ProfilingDuplicateID.html")) t]
		    ["Custom profiling attribute"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CustomProfilingAttr.html")) t]
		    ["Using the role attribute for profiling"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ProfilingWithRole.html")) t]
		    )
	      (list "Chapter 23. Program listings"
		    ["External code files"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ProgramListings.html#ExternalCode")) t]
		    ["Annotating program listings"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/AnnotateListing.html")) t]
		    )
	      (list "Chapter 24. Q and A sets"
		    ["Q and A labeling"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/QandASetsHTML.html#QandAlabels")) t]
		    ["Q and A formatting"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/QandAformat.html")) t]
		    ["Q and A list of questions"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/QandAtoc.html")) t]
		    ["Chunking Q and A"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/QandAchunking.html")) t]
		    )
	      (list "Chapter 25. Tables"
		    ["Table width"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Tables.html#TableWidth")) t]
		    ["Column widths"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/ColumnWidths.html")) t]
		    ["Cell spacing and cell padding"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CellSpacing.html")) t]
		    ["Row height"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/RowHeight.html")) t]
		    ["Cell alignment"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CellAlignment.html")) t]
		    ["Cell spanning"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CellSpans.html")) t]
		    ["Borders"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Borders.html")) t]
		    ["Background color"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/BGtableColor.html")) t]
		    ["Applying CSS styles to table cells"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/CSSTableCells.html")) t]
		    ["Table summary"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/TableSummary.html")) t]
		    )
	      (list "Chapter 26. Website"
		    ["Creating a webpage XML file"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/Website.html#WebpageFile")) t]
		    ["Structuring your webpages"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/WebpageStruct.html")) t]
		    ["Generating your webpages"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/GenerateWebpages.html")) t]
		    ["Linking between pages"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/WebsiteOlinks.html")) t]
		    ["Linking to other sites"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/LinkingToSites.html")) t]
		    ["Adding other content"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/AddingContent.html")) t]
		    ["Website with XML catalogs"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/WebsiteCatalog.html")) t]
		    ["Website formatting"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/WebsiteFormat.html")) t]
		    )
	      )
	(list "Appendix A. A brief introduction to XSL"
	      (list "XSL processing model"
		    ["Context is important"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/IntroXSL.html#d0e30336")) t]
		    ["Programming features"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/IntroXSL.html#d0e30484")) t]
		    ["Generating HTML output"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/IntroXSL.html#d0e30634")) t]
		    ["Generating formatting objects"
		     (browse-url (concat docbook-menu-xsl-tcg-uri "/IntroXSL.html#d0e30735")) t]
		    )
	      )
	(list "Appendix B. Debugging XSL stylesheets"
	      ["Inserting messages"
	       (browse-url (concat docbook-menu-xsl-tcg-uri "/DebuggingXSL.html#DebugMessages")) t]
	      ["Using an XSLT debugger"
	       (browse-url (concat docbook-menu-xsl-tcg-uri "/XSLTDebugger.html")) t]
	      )
	["Glossary"
	 (browse-url (concat docbook-menu-xsl-tcg-uri "/glossary.html")) t]
	["Index"
	 (browse-url (concat docbook-menu-xsl-tcg-uri "/bookindex.html")) t]
	)
  "DocBook XSL: The Complete Guide submenu for 'docbook-menu'."
  )