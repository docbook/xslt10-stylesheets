VPATH=src

.SUFFIXES: .rnc .rng .rnx
.PHONY: tests html

RNCFILES=$(subst $(VPATH)/,,$(wildcard $(VPATH)/*.rnc))

all: docbook.rng docbook.dtd

# ============================================================

tests:
	mkdir -p tests tests/passed
	cd tests && ../tools/runtests

# ============================================================

docbook.rng: $(RNCFILES)
	$(MAKE) -C build $@
	trang $@ docbook.rnc

docbook-rng.xml: docbook.rng tools/rngdocxml.xsl
	xsltproc -output $@ tools/rngdocxml.xsl $<

docbook-dtd.xml: docbook-rng.xml tools/doc2dtd.xsl
	xsltproc -output $@ tools/doc2dtd.xsl $<

docbook.dtd: docbook-dtd.xml tools/xml2dtd.xsl
	xsltproc -output $@ tools/xml2dtd.xsl $<

# ============================================================

clean:
	rm -f *-rng.xml *-dtd.xml