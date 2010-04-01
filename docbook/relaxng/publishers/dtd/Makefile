include _header.mak

REMOVESCHEMATRON=1

SRCS = dtd.rnc

BINARY = dtd.rnd

all:: dtd.rnc dtd.rng

clean:: ; rm -f dtd.rng dtd.rnc

$(_OUTTOP)/dtd/dtd.rng: dtd/dtd.rnc publishers/publishers.rnc publishers/dcmitype.rnc publishers/dcterms.rnc

include _footer.mak

dtd.rng: $(basename $(dtd_BINARY)).rnx
	$(XSLTPROC) --param remove-schematron $(REMOVESCHEMATRON) --output $@ $(TOOLS)/removedoc.xsl $<

dtd.rnc: dtd.rng
	$(RUNTRANG) $< $@
