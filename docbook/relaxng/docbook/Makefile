# Inspired by "Recursive Make: Reloaded" in the July, 2005 issue
# of Linux Magazine, I've reworked the Makfiles so that they're no
# longer recursive.

# Fair warning, this is a bit more complex than is maybe ideal, but it
# works and it isn't recursive. I still need to get the documentation
# build into the new system.

include ../../../cvstools/Makefile.incl

XSLTPROC=xsltproc
PERL=perl
VERSION=5.0b1

TOOLS=../tools
AUGMENT=$(TOOLS)/augment.xsl
INCLUDE=$(TOOLS)/include.xsl
CLEANUP=$(TOOLS)/cleanup.pl

.PHONY: all

all::
_OUTTOP ?= .
_OUTTOP := $(_OUTTOP)/build

DISTRIB=$(_OUTTOP)/docbook-$(VERSION)

.PHONY: clean

clean:: ; rm -rf $(_OUTTOP)

.SUFFIXES:

MODULES=docbook dbforms defguide docbookxi

include $(addsuffix /Makefile,$(MODULES))

.PHONY: tests

distrib: docbook.dtd docbook.rng   docbook.rnc   docbook.sch \
                     docbookxi.rng docbookxi.rnc
	$(MAKE) -C howto
	$(MAKE) -C spec
	rm -rf $(DISTRIB)
	mkdir -p $(DISTRIB)/{rng,dtd,xsd,sch,docs,tools}
	mkdir $(DISTRIB)/docs/images
	echo $(VERSION) > $(DISTRIB)/VERSION
	cp docbook.{rng,rnc} docbookxi.{rng,rnc} $(DISTRIB)/rng/
	cp docbook.dtd $(DISTRIB)/dtd/
	cp docbook.sch $(DISTRIB)/sch/
	trang docbook.dtd $(DISTRIB)/xsd/docbook.xsd
	cp howto/howto.xml howto/howto.html howto/howto.pdf $(DISTRIB)/docs/
	cp howto/images/*.png $(DISTRIB)/docs/images/
	cp spec/docbook.xml spec/docbook.html spec/docbook.pdf $(DISTRIB)/docs/
	saxon -8b ../tools/catalog.xsl ../tools/catalog.xsl $(DISTRIB)/catalog.xml version=$(VERSION)
	cp ../tools/db4-upgrade.xsl $(DISTRIB)/tools/
	cp ../tools/db4-entities.pl $(DISTRIB)/tools/
	cp README $(DISTRIB)/
