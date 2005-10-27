include ../../../../cvstools/Makefile.incl

HTMLSTYLE=html.xsl
FOSTYLE=fo.xsl

XSLPARAM=""

all: docbook.html docbook.pdf

docbook.html: docbook.xml
	jing ../docbook.rng $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

docbook.fo: docbook.xml
	jing ../docbook.rng $<
	$(XSLT) $< $(FOSTYLE) docbook.fo $(XSLPARAM)

docbook.pdf: docbook.fo
	xep $<

elemdiff.xml: elemdiff.pl 44-50-elements.diff
	perl elemdiff.pl > $@

cmdiff.xml: cmdiff.pl 44-50-cm.diff
	perl cmdiff.pl > $@

showdiff.html: showdiff.xml elemdiff.xml cmdiff.xml
	xmllint --xinclude $< > ,$<
	saxon ,$< /sourceforge/docbook/xsl/html/docbook.xsl $@
	rm -f ,$<

clean:
	$(RM) *.html
