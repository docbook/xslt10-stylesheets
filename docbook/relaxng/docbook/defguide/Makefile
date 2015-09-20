# This Makefile builds the $(_OUTTOP)/defguide/defguide.rnd file used by
# the documentation build process. It doesn't actually build any schemas.
# The defguide.rnc file is arranged to be an exact copy of docbook.rnc
# except that it excludes the xinclude module. This dramatically simplifies
# the content models for the purpose of documentation.

include _header.mak

SRCS = defguide.rnc

BINARY = defguide.rnd

all:: defguide.rng defguide.rnc defguide.dtd

clean:: ; rm -f defguide.rng defguide.rnc defguide.dtd

$(_OUTTOP)/defguide/defguide.rng: src/annotations.rnc src/bibliography.rnc \
             src/callouts.rnc src/calstbl.rnc dbforms/htmlform.rnc \
             src/docbook.rnc src/ebnf.rnc src/glossary.rnc \
             src/hier.rnc src/htmltbl.rnc \
             src/index.rnc src/math.rnc src/mathml.rnc \
             src/msgset.rnc src/pool.rnc src/qandaset.rnc \
             src/refentry.rnc src/refsect1.rnc src/sect1.rnc \
             src/svg.rnc src/tasks.rnc src/toc.rnc \
             docbookxi/xinclude.rnc src/xlink.rnc

include _footer.mak

defguide.rng: $(basename $(defguide_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/removedoc.xsl $<

defguide.rnc: defguide.rng
	$(RUNTRANG) $< $@

defguide.dtd: $(basename $(defguide_BINARY)).dtx defguide.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<
