include ../../../cvstools/Makefile.incl

SCHEMADIR=../../../schema
RELAXNG=$(SCHEMADIR)/relaxng
DOCBOOKRNG=/share/doctypes/docbook42/relaxng

all: slidesdb.rng

config.xml: union.xml
	$(XSLT) $(RELAXNG)/simple/config.xml $(SCHEMADIR)/tools/union-config.xsl $@ \
                union.xml=/sourceforge/docbook/slides/schema/relaxng/union.xml

slidesdb.rng: config.xml
	$(XSLT) $(DOCBOOKRNG)/docbook.rng $(SCHEMADIR)/tools/configure.xsl $@ \
                config=/sourceforge/docbook/slides/schema/relaxng/$<

