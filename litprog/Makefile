include ../cvstools/Makefile.incl

all: tangle.html weave.html litprog.html

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

litprog.html: litprog.xml litprog.xsl
	$(XSLT) $< litprog.xsl $@

litprog.xml: litprog.xweb weave.xsl
	$(XSLT) $< weave.xsl $@

litprog.xsl: litprog.xweb tangle.xsl
	$(XSLT) $< tangle.xsl $@
