include ../../../cvstools/Makefile.incl

XJPARSE=/home/ndw/bin/xjparse

HTMLSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl
FOSTYLE=fo.xsl

XSLPARAM=""

all: docbook-simple.html

docbook-simple.html: docbook-simple.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

docbook-simple.fo: docbook-simple.xml
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) docbook-simple.fo $(XSLPARAM)

docbook-simple.pdf: docbook-simple.fo
	xep $<

clean:
	$(RM) *.html
