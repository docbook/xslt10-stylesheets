include ../../../cvstools/Makefile.incl

SCHEMADIR=../../../schema
RELAXNG=$(SCHEMADIR)/relaxng

all: websitedb.rng

elements.xml: union.xml
	$(XSLT) $(RELAXNG)/simple/elements.xml $(RELAXNG)/tools/union-elements.xsl $@ \
                union.xml=/sourceforge/docbook/website/schema/relaxng/union.xml

websitedb.rng: elements.xml
	$(XSLT) $(RELAXNG)/docbook.rng $(RELAXNG)/tools/subset.xsl $@ \
                elements=/sourceforge/docbook/website/schema/relaxng/$< \
                remove.start=1
