include ../buildtools/Makefile.incl

XSLT=../buildtools/xslt -xsltproc
XTANGLE_PARAMS=suppress.doctype.in.output=1

.PHONY: modified-markup.xsl docbook.rng xtangle.xsl w2docbook.xsl cldocbook.xsl ldocbook.xsl

MAKE_DOCBOOK_RNG=.make-docbook-rng.xsl
MAKE_LITPROG=.make-litprog.xsl

all: modified-markup.xsl docbook.rng xtangle.xsl w2docbook.xsl freshmeat-submit

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

freshmeat-submit:
	$(MAKE) -C ../contrib/tools/freshmeat-submit
	cp ../contrib/tools/freshmeat-submit/freshmeat-submit-1.6/$@ .

clean:
	$(RM) modified-markup.xsl
	$(RM) docbook.rng
	$(RM) VERSION
	$(RM) xtangle.xsl w2docbook.xsl
	$(RM) freshmeat-submit
