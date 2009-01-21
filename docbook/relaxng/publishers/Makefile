# Inspired by "Recursive Make: Reloaded" in the July, 2005 issue
# of Linux Magazine, I've reworked the Makfiles so that they're no
# longer recursive.

# Fair warning, this is a bit more complex than is maybe ideal, but it
# works and it isn't recursive. I still need to get the documentation
# build into the new system.

include $(DOCBOOK_SVN)/buildtools/Makefile.incl

XSLTPROC=xsltproc
SAXON=$(DOCBOOK_SVN)/buildtools/saxon
PERL=perl
MV ?= mv

CLASS=wd
VERSION=5.0b4
SPECNAME=$(CLASS)-docbook-docbook-$(VERSION)

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

MODULES=publishers

include $(addsuffix /Makefile,$(MODULES))

.PHONY: tests

distrib:
	echo not working yet
