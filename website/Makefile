# $Id$

include ../cvstools/Makefile.incl

DISTRO=website
RELVER=$(shell cat ./VERSION)
ZIPVER=$(RELVER)
DISTRIB_DEPENDS=example

.PHONY : distrib clean example

all:
	$(MAKE) -C schema all
	$(MAKE) -C extensions all

example:
	$(MAKE) -C example DOCBOOK_WEBSITE=$(WEBSITEROOT)

clean:
	$(MAKE) -C extensions clean
	$(MAKE) -C example clean
	$(MAKE) -C example TEXTONLY=1 clean

realclean: clean
	$(MAKE) -C extensions realclean
	$(MAKE) -C example realclean

# the following is used only for release builds; ignore it if you
# are doing a non-release build
excludes:
	rm -f $(TMP)/tar.exclude
	touch $(TMP)/tar.exclude

include ../cvstools/Makefile.common
