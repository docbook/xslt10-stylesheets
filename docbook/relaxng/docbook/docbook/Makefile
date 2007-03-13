include _header.mak

REMOVESCHEMATRON=0

SRCS = docbook.rnc

BINARY = docbook.rnd

all:: docbook.rng docbook.rnc docbook.dtd docbook.sch docbook.xsd

clean:: ; rm -f docbook.rng docbook.rnc docbook.dtd docbook.sch

$(_OUTTOP)/docbook/docbook.rng: src/annotations.rnc src/bibliography.rnc \
             src/callouts.rnc src/calstbl.rnc \
             src/docbook.rnc src/ebnf.rnc src/glossary.rnc \
             src/hier.rnc src/htmltbl.rnc \
             src/index.rnc src/math.rnc src/mathml.rnc \
             src/msgset.rnc src/pool.rnc src/qandaset.rnc \
             src/refentry.rnc src/refsect1.rnc src/sect1.rnc \
             src/svg.rnc src/tasks.rnc src/toc.rnc \
             src/xlink.rnc

include _footer.mak

docbook.rng: $(basename $(docbook_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

docbook.rnc: docbook.rng
	$(RUNTRANG) $< $@

docbook.dtd: $(basename $(docbook_BINARY)).dtx docbook.rnc ../tools/xml2dtd.xsl
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

# N.B. the schematron stylesheet is an XSLT 2.0 stylesheet!
docbook.sch: $(basename $(docbook_BINARY)).rnx
	$(SAXON) $< $(TOOLS)/schematron.xsl $@

docbook.xsd: docbook.dtd
	$(RUNTRANG) $< $@

.PHONY: tests

tests:
	$(TOOLS)/runtests
