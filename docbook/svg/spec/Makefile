include ../../../cvstools/Makefile.incl

SPECVER=1.0-b2

ifeq ($(SPECVER),)
SPECSEP=
else
SPECSEP=-
endif

HTMLSTYLE=/projects/oasis/stylesheets/tr.xsl
HTML-CSS=http://www.oasis-open.org/docbook/spec.css

OASIS-LOGO=http://www.oasis-open.org/docbook/oasis.png
XSLPARAM="html.stylesheet=$(HTML-CSS) oasis.logo=$(OASIS-LOGO)"

svg.html: svg.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) docbook-svg$(SPECSEP)$(SPECVER).html $(XSLPARAM)

clean:
	$(RM) *.html
