include ../../cvstools/Makefile.incl

SPECVER=

ifeq ($(SPECVER),)
SPECSEP=
else
SPECSEP=-
endif

HTMLSTYLE=/projects/oasis/stylesheets/tr.xsl
HTML-CSS=spec.css

OASIS-LOGO=http://www.oasis-open.org/docbook/oasis.png
XSLPARAM=html.stylesheet=$(HTML-CSS) oasis.logo=$(OASIS-LOGO)

XSLT=saxon

all: entities.html

tables:
	perl gentext.pl

entities.html: entities.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) entities$(SPECSEP)$(SPECVER).html $(XSLPARAM)
