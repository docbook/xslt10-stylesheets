include _header.mak

REMOVESCHEMATRON=0

SRCS = website.rnc

BINARY = website.rnd

all:: website.rng website.rnc website.dtd website.sch website.xsd

clean:: ; rm -f website.rng website.rnc website.dtd website.sch *.xsd

$(_OUTTOP)/website/website.rng: src/webpages.rnc src/rddl.rnc \
                                website/website.rnc \
                                ../simple/sdocbook.rnc \
                                ../docbook/dbforms/htmlform.rnc

include _footer.mak

website.rng: $(basename $(website_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

website.rnc: website.rng
	$(RUNTRANG) $< $@

website.dtd: $(basename $(website_BINARY)).dtx website.rnc
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

website.sch: $(basename $(website_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/schematron.xsl $<

website.xsd: website.dtd
	$(RUNTRANG) $< $@

