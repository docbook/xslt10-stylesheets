include ../buildtools/Makefile.incl

XSLT=../buildtools/xslt -xsltproc
XTANGLE_PARAMS=suppress.doctype.in.output=1

.PHONY: modified-markup.xsl docbook.rng xtangle.xsl w2docbook.xsl

MAKE_DOCBOOK_RNG=.make-docbook-rng.xsl
MAKE_LITPROG=.make-litprog.xsl

all: modified-markup.xsl docbook.rng xtangle.xsl w2docbook.xsl refentry.007.xml refentry.007.ns.xml

modified-markup.xsl:
	$(MAKE) -C ../contrib/tools/tennison $@
	cp ../contrib/tools/tennison/$@ .

docbook.rng:
	$(MAKE) -C ../docbook/relaxng/docbook $@
	$(XSLT) $(XSLTOPT) ../docbook/relaxng/docbook/$@ $(MAKE_DOCBOOK_RNG) > $@

xtangle.xsl:
	$(MAKE) -C ../litprog XTANGLE_PARAMS=$(XTANGLE_PARAMS)
	$(XSLT) $(XSLTOPT) ../litprog/$@ $(MAKE_LITPROG) filename=$@ > $@

w2docbook.xsl:
	$(MAKE) -C ../litprog XTANGLE_PARAMS=$(XTANGLE_PARAMS)
	$(XSLT) $(XSLTOPT) ../litprog/$@ $(MAKE_LITPROG) filename=$@ > $@

refentry.007.xml: ../testdocs/tests/refentry.007.xml
	cp $< $@

%.ns.xml: %.xml
	$(XSLT) $< ../xsl/tools/xsl/build/db4-upgrade.xsl > $@

clean:
	$(RM) modified-markup.xsl
	$(RM) docbook.rng
	$(RM) VERSION.xsl
	$(RM) xtangle.xsl w2docbook.xsl
	$(RM) refentry.007.xml refentry.007.ns.xml
