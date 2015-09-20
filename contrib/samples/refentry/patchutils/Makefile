HOST=sources.redhat.com
BASE=/cvs/patchutils
MODULE=patchutils/doc
FILE=patchutils.xml

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

CVS=cvs
CVSFLAGS=

all: $(FILE) Makefile.DocBook

$(FILE):
	(cd $(TMP) && $(CVS) $(CVSFLAGS) -d:pserver:anoncvs@$(HOST):$(BASE) co $(MODULE))
	cp $(TMP)/$(MODULE)/$(FILE) .

Makefile.DocBook:
	cp $(MAKEFILE_DOCBOOK) .

clean:
	$(RM) $(FILE)
	$(RM) Makefile.DocBook
