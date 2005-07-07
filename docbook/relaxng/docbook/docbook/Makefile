include _header.mak

SRCS = docbook.rnc

BINARY = docbook.rnd

all:: docbook.rng docbook.rnc docbook.dtd

$(_OUTTOP)/docbook/docbook.rng: src/annotations.rnc src/bibliography.rnc \
             src/callouts.rnc src/calstbl.rnc src/dbforms.rnc \
             src/docbook.rnc src/ebnf.rnc src/glossary.rnc \
             src/hier.rnc src/htmlform.rnc src/htmltbl.rnc \
             src/index.rnc src/math.rnc src/mathml.rnc \
             src/msgset.rnc src/pool.rnc src/qandaset.rnc \
             src/refentry.rnc src/refsect1.rnc src/sect1.rnc \
             src/svg.rnc src/tasks.rnc src/toc.rnc \
             src/xinclude.rnc src/xlink.rnc

include _footer.mak

docbook.rng: $(basename $(docbook_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/removedoc.xsl $<

docbook.rnc: docbook.rng
	$(RUNTRANG) $< $@

docbook.dtd: $(basename $(docbook_BINARY)).dtx docbook.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

.PHONY: tests

tests:
	$(TOOLS)/runtests
