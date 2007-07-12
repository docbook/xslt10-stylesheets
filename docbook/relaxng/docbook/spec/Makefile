include ../../../../buildtools/Makefile.incl

SAXON=$(CVSTOOLSROOT)/saxon
XSLT=$(SAXON)
HTMLSTYLE=html.xsl
FOSTYLE=fo.xsl
XML2RFC=/share/doctypes/ietf/xml2rfc/xml2rfc.tcl
RFCBASE=draft-walsh-app-docbook-xml-
RFCVERSION=00

XSLPARAM=

all: docbook.html docbook.pdf

docbook.html: docbook.xml html.xsl
	jing ../docbook.rng $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	tidy -q -utf8 -mn -asxml $@

docbook.fo: docbook.xml fo.xsl
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
	$(SAXON) ,$< /sourceforge/docbook/xsl/html/docbook.xsl $@
	rm -f ,$<

rfc: $(RFCBASE)$(RFCVERSION).html $(RFCBASE)$(RFCVERSION).txt

$(RFCBASE)$(RFCVERSION).html: rfc.xml
	$(XML2RFC) $< $@

$(RFCBASE)$(RFCVERSION).txt: rfc.xml
	$(XML2RFC) $< $@

clean:
	$(RM) *.html
