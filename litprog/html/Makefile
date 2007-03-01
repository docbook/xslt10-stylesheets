include ../../buildtools/Makefile.incl

all: ldocbook.xsl cldocbook.xsl

xml: ldocbook.xml

html: ldocbook.html

ldocbook.html: ldocbook.xml ldocbook.xsl
	$(XSLT) $< ldocbook.xsl $@

ldocbook.xml: ldocbook.xweb ../w2docbook.xsl
	$(XSLT) $< ../w2docbook.xsl $@

ldocbook.xsl: ldocbook.xweb ../xtangle.xsl
	$(XSLT) $< ../xtangle.xsl $@

cldocbook.xsl: ldocbook.xweb ../xtangle.xsl
	$(XSLT) $< ../xtangle.xsl $@ top=top-chunk

realclean: clean
	rm -f ldocbook.xsl

clean:
	rm -f ldocbook.html ldocbook.xml

