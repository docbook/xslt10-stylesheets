include _header.mak

REMOVESCHEMATRON=0

SRCS = slides-full.rnc

BINARY = slides-full.rnd

all:: slides-full.rng slides-full.rnc slides-full.dtd slides-full.sch slides-full.xsd

clean:: ; rm -f slides-full.rng slides-full.rnc slides-full.dtd slides-full.sch *.xsd

$(_OUTTOP)/slides-full/slides-full.rng: src/foils.rnc \
                              slides-full/slides-full.rnc \
                              ../docbook/docbook.rnc

include _footer.mak

slides-full.rng: $(basename $(slides-full_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

slides-full.rnc: slides-full.rng
	$(RUNTRANG) $< $@

slides-full.dtd: $(basename $(slides-full_BINARY)).dtx slides-full.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

slides-full.sch: $(basename $(slides-full_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/schematron.xsl $<

slides-full.xsd: slides-full.dtd
	$(RUNTRANG) $< $@

