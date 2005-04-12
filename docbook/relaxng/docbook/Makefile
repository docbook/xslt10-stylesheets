VPATH=src

.SUFFIXES: .rnc .rng .rnx
.PHONY: tests html

RNCFILES=$(subst $(VPATH)/,,$(wildcard $(VPATH)/*.rnc))
TOOLS=../tools

all: docbook.rng docbook.dtd

# ============================================================

tests:
	mkdir -p tests tests/passed
	cd tests && ../$(TOOLS)/runtests

# ============================================================

docbook.rng: $(RNCFILES)
	$(MAKE) -C build $@
	trang $@ docbook.rnc

docbook-rng.xml: docbook.rng $(TOOLS)/rngdocxml.xsl
	xsltproc -output $@ $(TOOLS)/rngdocxml.xsl $<

docbook-dtd.xml: docbook-rng.xml $(TOOLS)/doc2dtd.xsl
	xsltproc -output $@ $(TOOLS)/doc2dtd.xsl $<

docbook.dtd: docbook-dtd.xml $(TOOLS)/xml2dtd.xsl
	xsltproc -output $@ $(TOOLS)/xml2dtd.xsl $<

# ============================================================

clean:
	rm -f *-rng.xml *-dtd.xml