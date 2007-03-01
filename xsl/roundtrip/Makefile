include ../../buildtools/Makefile.incl

XSLFILES=param.xsl
ALLTARGETS=$(XSLFILES)
PROFILECONDITION=roundtrip

# Change this to where you are storing your roundtripping stylesheets
STYLESHEETDIR = .

WORDML = $(STYLESHEETDIR)/docbook.xsl
PAGES = $(STYLESHEETDIR)/docbook-pages.xsl
DBKNORM = $(STYLESHEETDIR)/wordml-normalise.xsl
PAGESNORM = $(STYLESHEETDIR)/pages-normalise.xsl
DBKSECTS = $(STYLESHEETDIR)/wordml-sections.xsl
DBKBLOCKS = $(STYLESHEETDIR)/wordml-blocks.xsl
DBKFINAL = $(STYLESHEETDIR)/wordml-final.xsl
TEMPLATE = $(STYLESHEETDIR)/template.xml
TEMPLATEPAGES = $(STYLESHEETDIR)/template-pages.xml

PROC = xsltproc

include ../Makefile.incl

# WordML-to-DocBook
%.docbook.xml: %.blocks.xml $(DBKFINAL) Makefile
	$(PROC) -o $@ $(DBKFINAL) $<

%.blocks.xml: %.sects.xml $(DBKBLOCKS) Makefile
	$(PROC) -o $@ $(DBKBLOCKS) $<

%.sects.xml: %.norm.xml $(DBKSECTS) Makefile
	$(PROC) -o $@ $(DBKSECTS) $<

%.norm.xml: %.wordml.xml $(DBKNORM) Makefile
	$(PROC) -o $@ $(DBKNORM) $<

# Pages-to-DocBook
%.pdocbook.xml: %.pblocks.xml $(DBKFINAL) Makefile
	$(PROC) -o $@ $(DBKFINAL) $<

%.pblocks.xml: %.psects.xml $(DBKBLOCKS) Makefile
	$(PROC) -o $@ $(DBKBLOCKS) $<

%.psects.xml: %.pnorm.xml $(DBKSECTS) Makefile
	$(PROC) -o $@ $(DBKSECTS) $<

%.pnorm.xml: %.pages.xml $(PAGESNORM) Makefile
	$(PROC) -o $@ $(PAGESNORM) $<

# DocBook-to-WordML
%.wordml.xml : %.xml $(WORDML) $(TEMPLATE) Makefile
	$(PROC) -o $@ --stringparam wordml.template $(TEMPLATE) $(WORDML) $<

# DocBook-to-Pages
%.pages.xml: %.xml $(PAGES) $(TEMPLATEPAGES) Makefile
	$(PROC) -o $@ --stringparam pages.template $(TEMPLATEPAGES) $(PAGES) $<
