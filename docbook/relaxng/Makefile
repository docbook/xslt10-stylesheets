VPATH=src

.SUFFIXES: .rnc .rng .rnx
.PHONY: tests html

RNCFILES=$(subst $(VPATH)/,,$(wildcard $(VPATH)/*.rnc))

all: docbook.rng

docbook.rng: $(RNCFILES)
	$(MAKE) -C build $@

dbsmall.rng: $(RNCFILES)
	$(MAKE) -C build $@

dbastro.rng: $(RNCFILES)
	$(MAKE) -C build $@

tests:
	mkdir -p tests tests/passed
	cd tests && ../tools/runtests

html: docbook-rng.xml
	xsltproc tools/html.xsl $<

docbook-rng.xml: docbook.rng tools/rngdocxml.xsl tools/rngdocxml-multipass.xsl
	tools/makedoc $< $@

#	xsltproc -output $@ tools/rngdocxml.xsl $<

clean:
	rm -f out*
