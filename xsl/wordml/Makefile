STYLESHEETDIR = .

WORDML = $(STYLESHEETDIR)/docbook.xsl
DBKNORM = $(STYLESHEETDIR)/wordml-normalise.xsl
DBKSECTS = $(STYLESHEETDIR)/wordml-sections.xsl
DBKFINAL = $(STYLESHEETDIR)/wordml-final.xsl
TEMPLATE = /Users/steve/Projects/docbook-cvs/xsl/wordml/template.xml

PROC = xsltproc

%.docbook.xml: %.sects.xml $(DBKFINAL) Makefile
	$(PROC) -o $@ $(DBKFINAL) $<

%.sects.xml: %.norm.xml $(DBKSECTS) Makefile
	$(PROC) -o $@ $(DBKSECTS) $<

%.norm.xml: %.wordml.xml $(DBKNORM) Makefile
	$(PROC) -o $@ $(DBKNORM) $<

%.wordml.xml : %.xml $(WORDML) Makefile
	xsltproc -o $@ --stringparam wordml.template $(TEMPLATE) $(WORDML) $<
