include ../../cvstools/Makefile.incl

SPECVER=4.2

ifeq ($(SPECVER),)
SPECSEP=
else
SPECSEP=-
endif

HTMLSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-html.xsl
FOSTYLE=/projects/oasis/spectools/stylesheets/oasis-docbook-fo.xsl

XSLPARAM=""

cs-docbook-docbook.html: cs-docbook-docbook.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $(XSLPARAM)

cs-docbook-docbook.pdf: cs-docbook-docbook.xml
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) cs-docbook-docbook$(SPECSEP)$(SPECVER).fo $(XSLPARAM)
	xep cs-docbook-docbook$(SPECSEP)$(SPECVER).fo
	rm -f cs-docbook-docbook$(SPECSEP)$(SPECVER).fo

clean:
	$(RM) *.html
