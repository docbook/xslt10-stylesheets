include ../../cvstools/Makefile.incl

SPECVER=4.2-CR1

ifeq ($(SPECVER),)
SPECSEP=
else
SPECSEP=-
endif

HTMLSTYLE=/projects/oasis/stylesheets/tr.xsl
HTML-CSS=spec.css

OASIS-LOGO=http://www.oasis-open.org/docbook/oasis.png
XSLPARAM="html.stylesheet=$(HTML-CSS) oasis.logo=$(OASIS-LOGO)"

docbook.html: docbook.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) docbook$(SPECSEP)$(SPECVER).html $(XSLPARAM)

clean:
	$(RM) *.html
