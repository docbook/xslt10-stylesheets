include ../../../cvstools/Makefile.incl

all: simple.rng

simple.rng: elements.xml ../docbook.rng ../dbpool.rng ../dbhier.rng ../dbnotn.rng
	$(XSLT) ../docbook.rng ../../tools/subset.xsl $@ \
          elements=/sourceforge/docbook/schema/relaxng/simple/elements.xml
