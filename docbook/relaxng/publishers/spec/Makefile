include ../../../../buildtools/Makefile.incl

SAXON=$(CVSTOOLSROOT)/saxon
XSLT=$(SAXON)
HTMLSTYLE=html.xsl
FOSTYLE=fo.xsl
XML2RFC=/share/doctypes/ietf/xml2rfc/xml2rfc.tcl
RFCBASE=draft-walsh-app-publishers-xml-
RFCVERSION=00
TIDY=tidy

XSLPARAM=

all: publishers.html publishers.pdf

publishers.html: publishers.xml html.xsl
	jing ../publishers.rng $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(XSLPARAM)
	$(TIDY) -q -utf8 -mn -asxml $@

publishers.fo: publishers.xml fo.xsl
	jing ../publishers.rng $<
	$(XSLT) $< $(FOSTYLE) publishers.fo $(XSLPARAM)

publishers.pdf: publishers.fo
	xep -q $<

elemdiff.xml: elemdiff.pl 44-50-elements.diff
	perl elemdiff.pl > $@

cmdiff.xml: cmdiff.pl 44-50-cm.diff
	perl cmdiff.pl > $@

showdiff.html: showdiff.xml elemdiff.xml cmdiff.xml
	xmllint --xinclude $< > ,$<
	$(SAXON) ,$< /sourceforge/publishers/xsl/html/publishers.xsl $@
	rm -f ,$<

rfc: $(RFCBASE)$(RFCVERSION).html $(RFCBASE)$(RFCVERSION).txt

$(RFCBASE)$(RFCVERSION).html: rfc.xml
	$(XML2RFC) $< $@

$(RFCBASE)$(RFCVERSION).txt: rfc.xml
	$(XML2RFC) $< $@

clean:
	$(RM) *.html
