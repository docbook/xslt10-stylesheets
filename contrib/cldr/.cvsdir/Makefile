# $Id$

DATE ?= $(shell date +"%Y-%m-%d")

WGET ?= wget
WGET_OPTS ?=

BASE_CDLR_URL ?= http://ftp.unicode.org/Public/cldr
SNAPSHOT_FILENAME ?= cldr-repository-daily.tgz

SNAPSHOT_BASENAME ?= $(basename $(SNAPSHOT_FILENAME))
ADJUSTED_FILENAME ?= $(SNAPSHOT_BASENAME).$(DATE).tgz

all: cldr

$(ADJUSTED_FILENAME):
	$(WGET) $(BASE_CDLR_URL)/$(SNAPSHOT_FILENAME)
	tar xvfz $(SNAPSHOT_FILENAME) && $(RM) $(SNAPSHOT_BASENAME).*.tgz
	mv $(SNAPSHOT_FILENAME) $@

cldr: $(ADJUSTED_FILENAME)
	$(RM) -r CVSROOT/ cldr/
	tar xvfz $<

clean:
	$(RM) -r cldr/ CVSROOT/
	$(RM) -r $(ADJUSTED_FILENAME) cldr/ CVSROOT/
