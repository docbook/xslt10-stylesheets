include ../cvstools/Makefile.incl

all: tangle.xsl weave.xsl wdocbook.xsl
	$(MAKE) -C html

xml: tangle.xml weave.xml wdocbook.xml

html: xml tangle.html weave.html wdocbook.html

tangle.html: tangle.xml html/ldocbook.xsl
	$(XSLT) $< html/ldocbook.xsl $@

tangle.xml: tangle.xweb wdocbook.xsl
	$(XSLT) $< wdocbook.xsl $@

# Can this rule be improved? Ideally bootstrap-tangle should only be
# required if tangle.xsl doesn't exist. If it exists but is out-of-date
# it can rebuild itself.
tangle.xsl: tangle.xweb bootstrap-tangle.xsl
	$(XSLT) $< bootstrap-tangle.xsl .temp.xsl
	$(XSLT) $< .temp.xsl tangle.xsl
	rm -f .temp.xsl

weave.html: weave.xml html/ldocbook.xsl
	$(XSLT)  $< html/ldocbook.xsl $@

weave.xml: weave.xweb wdocbook.xsl
	$(XSLT)  $< wdocbook.xsl $@
	xjparse $@

weave.xsl: weave.xweb tangle.xsl
	$(XSLT)  $< tangle.xsl $@

wdocbook.html: wdocbook.xml wdocbook.xsl
	$(XSLT) $< wdocbook.xsl $@

wdocbook.xml: wdocbook.xweb wdocbook.xsl
	$(XSLT) $< wdocbook.xsl $@

wdocbook.xsl: wdocbook.xweb tangle.xsl
	$(XSLT) $< tangle.xsl $@

clean:
	rm -f weave.{xsl,xml,html}
	rm -f tangle.{xsl,xml,html}
	rm -f wdocbook.{xsl,xml,html}
