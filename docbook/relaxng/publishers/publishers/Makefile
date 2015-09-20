include _header.mak

REMOVESCHEMATRON=0

SRCS = publishers.rnc

BINARY = publishers.rnd

# Fixme: publishers.dtd doesn't build (so can't build publishers.xsd)
all:: publishers.rng publishers.rnc publishers.sch

clean:: ; rm -f publishers.rng publishers.rnc publishers.dtd publishers.sch *.xsd

$(_OUTTOP)/publishers/publishers.rng: publishers/publishers.rnc \
                                  ../docbook/src/core.rnc \
                                  publishers/dcterms.rnc \
                                  publishers/dcmitype.rnc

include _footer.mak

publishers.rng: $(basename $(publishers_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

publishers.rnc: publishers.rng
	$(RUNTRANG) $< $@

publishers.dtd: $(basename $(publishers_BINARY)).dtx publishers.rnc
	$(XSLTPROC) --output $@ $(TOOLS)/xml2dtd.xsl $<

publishers.sch: $(basename $(publishers_BINARY)).rnx
	$(SAXON) $< $(TOOLS)/schematron.xsl $@

publishers.xsd: publishers.dtd
	$(RUNTRANG) $< $@

