include ../../../cvstools/Makefile.incl

XJPARSE=/home/ndw/bin/xjparse

HTMLSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl
FOSTYLE=fo.xsl

XSLPARAM=""

all: htmlforms.html

htmlforms.html: htmlforms.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

htmlforms.fo: htmlforms.xml
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) htmlforms.fo $(XSLPARAM)

htmlforms.pdf: htmlforms.fo
	xep $<

clean:
	$(RM) *.html

