include ../../../buildtools/Makefile.incl

XJPARSE=/home/ndw/bin/xjparse

HTMLSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl
FOSTYLE=fo.xsl

XSLPARAM=""

all: mathml.html

mathml.html: mathml.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

mathml.fo: mathml.xml
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) mathml.fo $(XSLPARAM)

mathml.pdf: mathml.fo
	xep $<

clean:
	$(RM) *.html

