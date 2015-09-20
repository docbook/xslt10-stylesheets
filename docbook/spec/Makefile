include ../../buildtools/Makefile.incl

XJPARSE=/home/ndw/bin/xjparse
TIDY=tidy

HTMLSTYLE=html.xsl
FOSTYLE=fo.xsl

XSLPARAM=

all: docbook.html

docbook.html: docbook.xml html.xsl
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	$(TIDY) -q -utf8 -mn -asxml $@

docbook.fo: docbook.xml fo.xsl
	$(XJPARSE) $<
	$(XSLT) $< $(FOSTYLE) docbook.fo $(XSLPARAM)

docbook.pdf: docbook.fo
	xep -q $<

clean:
	$(RM) -f *.html *.fo *.pdf
