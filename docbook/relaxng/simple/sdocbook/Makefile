include _header.mak

REMOVESCHEMATRON=0

SRCS = sdocbook.rnc

BINARY = sdocbook.rnd

all:: sdocbook.rng sdocbook.rnc sdocbook.dtd sdocbook.sch sdocbook.xsd

clean:: ; rm -f sdocbook.rng sdocbook.rnc sdocbook.dtd sdocbook.sch *.xsd

$(_OUTTOP)/sdocbook/sdocbook.rng: sdocbook/sdocbook.rnc \
                                  ../docbook/src/hier.rnc \
                                  ../docbook/src/bibliography.rnc \
                                  ../docbook/src/calstbl.rnc \
                                  ../docbook/src/htmltbl.rnc \
                                  ../docbook/src/pool.rnc

include _footer.mak

sdocbook.rng: $(basename $(sdocbook_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

sdocbook.rnc: sdocbook.rng
	$(RUNTRANG) $< $@

sdocbook.dtd: $(basename $(sdocbook_BINARY)).dtx sdocbook.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

sdocbook.sch: $(basename $(sdocbook_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/schematron.xsl $<

sdocbook.xsd: sdocbook.dtd
	$(RUNTRANG) $< $@

