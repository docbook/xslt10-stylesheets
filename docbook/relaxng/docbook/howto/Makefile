include ../../../../buildtools/Makefile.incl

HTMLSTYLE=stylesheets/html.xsl
FOSTYLE=stylesheets/fo.xsl
VARS=

all: howto.html howto.pdf

%.html : %.xml $(HTMLSTYLE)
	jing -c ../docbook.rnc $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(VARS)


%.fo : %.xml $(FOSTYLE)
	jing -c ../docbook.rnc $<
	$(XSLT) $< $(FOSTYLE) $@ xep.extensions=1 $(VARS)

%.pdf : %.fo
	xep $<
