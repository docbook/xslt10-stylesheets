include ../../../cvstools/Makefile.incl

XJPARSE=/home/ndw/bin/xjparse

HTMLSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl
FOSTYLE=fo.xsl

XSLPARAM=""

all: ebnf.html

ebnf.html: ebnf.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

ebnf.fo: ebnf.xml
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) ebnf.fo $(XSLPARAM)

ebnf.pdf: ebnf.fo
	xep $<

clean:
	$(RM) *.html

