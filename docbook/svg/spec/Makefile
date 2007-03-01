include ../../../buildtools/Makefile.incl

XJPARSE=/home/ndw/bin/xjparse

HTMLSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl
FOSTYLE=fo.xsl

XSLPARAM=""

all: svg.html

svg.html: svg.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

svg.fo: svg.xml
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) svg.fo $(XSLPARAM)

svg.pdf: svg.fo
	xep $<

clean:
	$(RM) *.html

