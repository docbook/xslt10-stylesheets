.SUFFIXES: .rnc .rng .rnx
.PHONY: tests html

DOCBOOK=../docbook
TOOLS=../tools
RNGFILES=$(wildcard build/*.rng)

all:
	$(MAKE) TOOLS=../../$(TOOLS) DOCBOOK=../../$(DOCBOOK) -C build/rnx
	$(MAKE) TOOLS=../$(TOOLS) DOCBOOK=../$(DOCBOOK) -C build
	$(MAKE) sdocbook.rng sdocbook.dtd

# ============================================================

sdocbook.rng: $(RNGFILES)
	$(MAKE) TOOLS=../$(TOOLS) -C build $@
	mv build/$@ .
	perl $(TOOLS)/trimgrammar.pl -o ,$@ $@
	saxon ,$@ $(TOOLS)/trimgrammar.xsl $@ use.extensions=1
	trang $@ sdocbook.rnc
	rm -f ,$@

sdocbook-rng.xml: sdocbook.rng $(TOOLS)/rngdocxml.xsl
	xsltproc -output $@ $(TOOLS)/rngdocxml.xsl $<

sdocbook-dtd.xml: sdocbook-rng.xml $(TOOLS)/doc2dtd.xsl
	xsltproc -output $@ $(TOOLS)/doc2dtd.xsl $<

sdocbook.dtd: sdocbook-dtd.xml $(TOOLS)/xml2dtd.xsl
	xsltproc -output $@ $(TOOLS)/xml2dtd.xsl $<

diff: sdocbook.rng
	saxon -8b $< alphalist-rng.xsl alphalist
	diff dtdlist alphalist | more

# ============================================================

html: sdocbook-rng.xml
	saxon $< $(TOOLS)/html.xsl /dev/null

# ============================================================

clean:
	rm -f *-dtd.xml *-rng.xml
