include ../buildtools/Makefile.incl

all: tangle.xsl weave.xsl w2docbook.xsl xtangle.xsl
	$(MAKE) -C html
	$(MAKE) -C example

xml: tangle.xml weave.xml
	$(MAKE) -C html xml
	$(MAKE) -C example xml

html: xml tangle.html weave.html
	$(MAKE) -C html html
	$(MAKE) -C example html

%.html: %.xml html/ldocbook.xsl
	$(XSLT) $< html/ldocbook.xsl $@

%.fo: %.xml fo/ldocbook.xsl
	$(XSLT) $< fo/ldocbook.xsl $@

%.pdf: %.fo
	xep $< $@
	rm -f $@

# Can this rule be improved? Ideally bootstrap-tangle should only be
# required if tangle.xsl doesn't exist. If it exists but is out-of-date
# it can rebuild itself.
xtangle.xsl: tangle.xweb bootstrap-tangle.xsl
	$(XSLT) $< bootstrap-tangle.xsl .boot.tangle.xsl
	$(XSLT) $< .boot.tangle.xsl $@ top=xtop
	rm -f .boot.tangle.xsl

tangle.xsl: tangle.xweb xtangle.xsl
	$(XSLT) $< xtangle.xsl $@

tangle.xml: tangle.xweb w2docbook.xsl
	$(XSLT) $< w2docbook.xsl $@

weave.xsl: weave.xweb xtangle.xsl
	$(XSLT)  $< xtangle.xsl $@

weave.xml: weave.xweb w2docbook.xsl
	$(XSLT)  $< w2docbook.xsl $@
	xjparse $@

w2docbook.xsl: weave.xweb xtangle.xsl weave.xsl
	$(XSLT) $< xtangle.xsl $@ top=w2docbook

realclean: clean
	rm -f xtangle.xsl
	rm -f weave.xsl w2docbook.xsl
	rm -f tangle.xsl
	$(MAKE) -C html realclean
	$(MAKE) -C fo realclean
	$(MAKE) -C example realclean

clean:
	rm -f weave.{xml,html,fo,pdf}
	rm -f tangle.{xml,html,fo,pdf}
	$(MAKE) -C html clean
	$(MAKE) -C fo clean
	$(MAKE) -C example clean



