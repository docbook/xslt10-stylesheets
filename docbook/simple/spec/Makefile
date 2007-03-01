include ../../../buildtools/Makefile.incl

XJPARSE=/home/ndw/bin/xjparse

HTMLSTYLE=html.xsl
FOSTYLE=fo.xsl
XSLT=saxon

XSLPARAM=

all: docbook-simple.html

docbook-simple.html: docbook-simple.xml html.xsl
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

docbook-simple.fo: docbook-simple.xml fo.xsl
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) docbook-simple.fo $(XSLPARAM)

docbook-simple.pdf: docbook-simple.fo
	xep $<

clean:
	$(RM) *.html
