include _header.mak

SRCS = dbforms.rnc

BINARY = dbforms.rnd

all:: dbforms.rng dbforms.rnc dbforms.dtd

clean:: ; rm -f dbforms.rng dbforms.rnc dbforms.dtd

$(_OUTTOP)/dbforms/dbforms.rng: dbforms/htmlform.rnc \
             src/annotations.rnc src/bibliography.rnc \
             src/callouts.rnc src/calstbl.rnc \
             src/docbook.rnc src/ebnf.rnc src/glossary.rnc \
             src/hier.rnc src/htmltbl.rnc \
             src/index.rnc src/math.rnc src/mathml.rnc \
             src/msgset.rnc src/pool.rnc src/qandaset.rnc \
             src/refentry.rnc src/refsect1.rnc src/sect1.rnc \
             src/svg.rnc src/tasks.rnc src/toc.rnc \
             docbookxi/xinclude.rnc src/xlink.rnc

include _footer.mak

dbforms.rng: $(basename $(docbook_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/removedoc.xsl $<

dbforms.rnc: dbforms.rng
	$(RUNTRANG) $< $@

dbforms.dtd: $(basename $(docbook_BINARY)).dtx dbforms.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<
