include ../cvstools/Makefile.incl

all: tangle.html weave.html wdocbook.html
	$(MAKE) -C html

tangle.html: tangle.xml litprog.xsl
	$(XSLT) $< litprog.xsl $@

tangle.xml: tangle.xweb weave.xsl
	$(XSLT) $< weave.xsl $@

# Can this rule be improved? Ideally bootstrap-tangle should only be
# required if tangle.xsl doesn't exist. If it exists but is out-of-date
# it can rebuild itself.
tangle.xsl: tangle.xweb bootstrap-tangle.xsl
	$(XSLT) $< bootstrap-tangle.xsl .temp.xsl
	$(XSLT) $< .temp.xsl tangle.xsl
	rm -f .temp.xsl

weave.html: weave.xml litprog.xsl
	$(XSLT)  $< litprog.xsl $@

weave.xml: weave.xweb weave.xsl
	$(XSLT)  $< weave.xsl $@
	xjparse $@

weave.xsl: weave.xweb tangle.xsl
	$(XSLT)  $< tangle.xsl $@

wdocbook.html: wdocbook.xml wdocbook.xsl
	$(XSLT) $< wdocbook.xsl $@

wdocbook.xml: wdocbook.xweb weave.xsl
	$(XSLT) $< weave.xsl $@

wdocbook.xsl: wdocbook.xweb tangle.xsl
	$(XSLT) $< tangle.xsl $@
