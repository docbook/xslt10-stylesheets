include ../../cvstools/Makefile.incl

all: ldocbook.xsl

xml: ldocbook.xml

html: ldocbook.html

ldocbook.html: ldocbook.xml ldocbook.xsl
	$(XSLT) $< ldocbook.xsl $@

ldocbook.xml: ldocbook.xweb ../wdocbook.xsl
	$(XSLT) $< ../wdocbook.xsl $@

ldocbook.xsl: ldocbook.xweb ../xtangle.xsl
	$(XSLT) $< ../xtangle.xsl $@

realclean: clean
	rm -f ldocbook.xsl

clean:
	rm -f ldocbook.html ldocbook.xml

