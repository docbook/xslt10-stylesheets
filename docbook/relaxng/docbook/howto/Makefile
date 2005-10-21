include ../../../../cvstools/Makefile.incl

HTMLSTYLE=stylesheets/html.xsl
FOSTYLE=stylesheets/fo.xsl
VARS=

all: howto.html

%.html : %.xml $(HTMLSTYLE)
	xjparse $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(VARS)


%.fo : %.xml $(FOSTYLE)
	xjparse $<
	$(XSLT) $< $(FOSTYLE) $@ xep.extensions=1 $(VARS)

%.pdf : %.fo
	xep $<

