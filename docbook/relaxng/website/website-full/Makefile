include _header.mak

REMOVESCHEMATRON=0

SRCS = website-full.rnc

BINARY = website-full.rnd

all:: website-full.rng website-full.rnc website-full.dtd website-full.sch website-full.xsd

clean:: ; rm -f website-full.rng website-full.rnc website-full.dtd website-full.sch *.xsd

$(_OUTTOP)/website-full/website-full.rng: src/webpages.rnc src/rddl.rnc \
                                website-full/website-full.rnc \
                                ../docbook/docbook.rnc \
                                ../docbook/dbforms/htmlform.rnc

include _footer.mak

website-full.rng: $(basename $(website-full_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

website-full.rnc: website-full.rng
	$(RUNTRANG) $< $@

website-full.dtd: $(basename $(website-full_BINARY)).dtx website-full.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

website-full.sch: $(basename $(website-full_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/schematron.xsl $<

website-full.xsd: website-full.dtd
	$(RUNTRANG) $< $@

