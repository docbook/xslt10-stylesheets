include ../../cvstools/Makefile.incl

all: ldocbook.html

ldocbook.html: ldocbook.xml ldocbook.xsl
	$(XSLT) $< ldocbook.xsl $@

ldocbook.xml: ldocbook.xweb ../wdocbook.xsl
	$(XSLT) $< ../wdocbook.xsl $@

ldocbook.xsl: ldocbook.xweb ../tangle.xsl
	$(XSLT) $< ../tangle.xsl $@

clean:
	rm -f ldocbook.html ldocbook.xml ldocbook.xsl
