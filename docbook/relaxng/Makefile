VPATH=src

.SUFFIXES: .rnc .rng .rnx
.PHONY: tests html

RNCFILES=$(subst $(VPATH)/,,$(wildcard $(VPATH)/*.rnc))

all: docbook.rng

docbook.rng: $(RNCFILES)
	$(MAKE) -C build $@

docbook-dtd.rng: $(RNCFILES)
	$(MAKE) -C build $@

dbsmall.rng: $(RNCFILES)
	$(MAKE) -C build $@

dbastro.rng: $(RNCFILES)
	$(MAKE) -C build $@

sdocbook.rng: $(RNCFILES)
	$(MAKE) -C build $@
	perl tools/trimgrammar.pl -o ,$@ $@
	saxon ,$@ tools/trimgrammar.xsl $@ use.extensions=1

slides-ng.rng: $(RNCFILES)
	$(MAKE) -C build $@
	perl tools/trimgrammar.pl -o ,$@ build/$@
	saxon ,$@ tools/trimgrammar.xsl $@ use.extensions=1

website-ng.rng: $(RNCFILES)
	$(MAKE) -C build $@
	perl tools/trimgrammar.pl -o ,$@ $@
	saxon ,$@ tools/trimgrammar.xsl $@ use.extensions=1

docbook.dtd: docbook-dtd.xml tools/doc2dtd.xsl
	xsltproc --output $@ tools/doc2dtd.xsl $<
	xjparse -d dtdtest.xml

tests:
	mkdir -p tests tests/passed
	cd tests && ../tools/runtests

html: docbook-rng.xml
	xsltproc tools/html.xsl $<

shtml: sdocbook-rng.xml
	xsltproc tools/html.xsl $<

docbook-rng.xml: docbook.rng tools/rngdocxml.xsl tools/rngdocxml-multipass.xsl
	xsltproc -output $@ tools/rngdocxml.xsl $<

docbook-dtd.xml: docbook-dtd.rng tools/rngdocxml.xsl tools/rngdocxml-multipass.xsl
	xsltproc -output $@ tools/rngdocxml.xsl $<

sdocbook-rng.xml: sdocbook.rng tools/rngdocxml.xsl tools/rngdocxml-multipass.xsl
	xsltproc -output $@ tools/rngdocxml.xsl $<

clean:
	rm -f out*
