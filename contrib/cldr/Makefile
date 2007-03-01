# $Id$

include ../../buildtools/Makefile.incl

CLDR_CVS_MODULES ?= common docs dtd tools

CLDR_CVS_DIR = .cvsdir

CLDR_CVS_PATH = $(shell readlink -f $(CLDR_CVS_DIR))

CVS ?= cvs
CVS_OPTS ?=

all: NEWS

$(CLDR_CVS_DIR)/cldr:
	$(MAKE) -C $(CLDR_CVS_DIR)

NEWS: $(CLDR_CVS_DIR)/cldr
	(cd ..; $(CVS) $(CVS_OPTS) -d $(CLDR_CVS_PATH) co cldr)
	$(CVS2LOG) -w
	touch ChangeLog
	$(MERGELOGS) -v NONE > $@
	find . -name CVS -type d | xargs $(RM) -r

clean:
	$(RM) -r $(CLDR_CVS_MODULES)
	$(RM) ChangeLog
	$(RM) NEWS

maintainer-clean: clean
	$(MAKE) -C $(CLDR_CVS_DIR) clean
