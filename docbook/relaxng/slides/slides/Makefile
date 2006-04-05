include _header.mak

REMOVESCHEMATRON=0

SRCS = slides.rnc

BINARY = slides.rnd

all:: slides.rng slides.rnc slides.dtd slides.sch slides.xsd

clean:: ; rm -f slides.rng slides.rnc slides.dtd slides.sch *.xsd

$(_OUTTOP)/slides/slides.rng: src/foils.rnc slides/slides.rnc \
                              ../simple/sdocbook.rnc

include _footer.mak

slides.rng: $(basename $(slides_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

slides.rnc: slides.rng
	$(RUNTRANG) $< $@

slides.dtd: $(basename $(slides_BINARY)).dtx slides.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

slides.sch: $(basename $(slides_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/schematron.xsl $<

slides.xsd: slides.dtd
	$(RUNTRANG) $< $@

