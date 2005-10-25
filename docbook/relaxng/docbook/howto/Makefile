include ../../../../cvstools/Makefile.incl

HTMLSTYLE=stylesheets/html.xsl
FOSTYLE=stylesheets/fo.xsl
VARS=

all: howto.html

%.html : %.xml $(HTMLSTYLE)
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(VARS)


%.fo : %.xml $(FOSTYLE)
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) $@ xep.extensions=1 $(VARS)

%.pdf : %.fo
	xep $<

