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
BIBLIO=file:///home/ndw/bibliography.xml
XSLPARAM="html.stylesheet=$(HTML-CSS) oasis.logo=$(OASIS-LOGO) bibliography.collection=$(BIBLIO)"

docbook.html: docbook.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) docbook$(SPECSEP)$(SPECVER).html $(XSLPARAM)
