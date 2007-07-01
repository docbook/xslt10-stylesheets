include ../buildtools/Makefile.incl

XSLT=../buildtools/xslt -xsltproc

.PHONY: modified-markup.xsl docbook.rng xtangle.xsl w2docbook.xsl cldocbook.xsl ldocbook.xsl

MAKE_DOCBOOK_RNG=.make-docbook-rng.xsl
MAKE_LITPROG=.make-litprog.xsl

all: modified-markup.xsl docbook.rng xtangle.xsl w2docbook.xsl cldocbook.xsl ldocbook.xsl

modified-markup.xsl:
	$(MAKE) -C ../contrib/tools/tennison $@
	cp ../contrib/tools/tennison/$@ .

docbook.rng:
	$(MAKE) -C ../docbook/relaxng/docbook $@
	$(XSLT) $(XSLTOPT) ../docbook/relaxng/docbook/$@ $(MAKE_DOCBOOK_RNG) > $@

xtangle.xsl:
	$(MAKE) -C ../litprog
	$(XSLT) $(XSLTOPT) ../litprog/$@ $(MAKE_LITPROG) filename=$@ > $@

w2docbook.xsl:
	$(MAKE) -C ../litprog
	$(XSLT) $(XSLTOPT) ../litprog/$@ $(MAKE_LITPROG) filename=$@ > $@

cldocbook.xsl:
	$(MAKE) -C ../litprog
	$(XSLT) $(XSLTOPT) ../litprog/html/$@ $(MAKE_LITPROG) filename=$@ > $@

ldocbook.xsl:
	$(MAKE) -C ../litprog
	$(XSLT) $(XSLTOPT) ../litprog/html/$@ $(MAKE_LITPROG) filename=$@ > $@

clean:
	$(RM) modified-markup.xsl
	$(RM) docbook.rng
	$(RM) VERSION
	$(RM) xtangle.xsl w2docbook.xsl cldocbook.xsl ldocbook.xsl
