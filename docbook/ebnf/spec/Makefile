include ../../../cvstools/Makefile.incl

XSLT=xsltproc

STATUS=wd
OASISTC=docbook
SPECNAME=ebnf
SPECVER=1.1-CR1

SPECROOT=$(STATUS)-$(OASISTC)-$(SPECNAME)
SPECBASE=$(SPECROOT)-$(SPECVER)

HTMLSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl
HTMLPARAM=

FOSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-fo.xsl
FOPARAM=oasis.logo=/projects/oasis/spectools/images/oasis.png

all: html pdf

valid: $(SPECROOT).xml
	$(XJPARSE) $<

html: $(SPECBASE).html

fo: $(SPECBASE).fo

pdf: $(SPECBASE).pdf

$(SPECBASE).html: $(SPECROOT).xml valid
	$(XSLT) $< $(HTMLSTYLE) $(SPECBASE).html $(HTMLPARAM)

$(SPECBASE).fo: $(SPECROOT).xml valid
	$(XSLT) $< $(FOSTYLE) $(SPECBASE).fo $(FOPARAM)

$(SPECBASE).pdf: $(SPECBASE).fo
	xep -2 $(SPECBASE).fo
	rm -f $(SPECBASE).fo

clean:
	$(RM) -f *.html *.pdf *.fo
