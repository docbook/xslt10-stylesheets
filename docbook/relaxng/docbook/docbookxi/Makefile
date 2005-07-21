# This Makefile builds the $(_OUTTOP)/docbookxi/docbookxi.rnd

include _header.mak

SRCS = docbookxi.rnc

BINARY = docbookxi.rnd

all:: docbookxi.rng docbookxi.rnc docbookxi.dtd

clean:: ; rm -f $(_MODULE)/docbookxi.rnc

$(_OUTTOP)/docbookxi/docbookxi.rng: src/annotations.rnc src/bibliography.rnc \
             src/callouts.rnc src/calstbl.rnc dbforms/htmlform.rnc \
             src/docbook.rnc src/ebnf.rnc src/glossary.rnc \
             src/hier.rnc src/htmltbl.rnc \
             src/index.rnc src/math.rnc src/mathml.rnc \
             src/msgset.rnc src/pool.rnc src/qandaset.rnc \
             src/refentry.rnc src/refsect1.rnc src/sect1.rnc \
             src/svg.rnc src/tasks.rnc src/toc.rnc \
             docbookxi/xinclude.rnc src/xlink.rnc

include _footer.mak

docbookxi.rng: $(basename $(docbookxi_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/removedoc.xsl $<

docbookxi.rnc: docbookxi.rng
	$(RUNTRANG) $< $@

docbookxi.dtd: $(basename $(docbookxi_BINARY)).dtx docbookxi.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<
