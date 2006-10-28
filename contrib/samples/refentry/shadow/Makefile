HOST=anoncvs.pld.org.pl
USER=cvs
BASE=/cvsroot
MODULE=shadow
SUBMODULE=man

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

CVS=cvs
CVSFLAGS=

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	(cd $(TMP) && $(CVS) $(CVSFLAGS) -d:pserver:$(USER)@$(HOST):$(BASE) co $(MODULE)/$(SUBMODULE))
	cp -pR $(TMP)/$(MODULE)/$(SUBMODULE) .

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
