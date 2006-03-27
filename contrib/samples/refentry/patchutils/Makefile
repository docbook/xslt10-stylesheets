HOST=sources.redhat.com
BASE=/cvs/patchutils
MODULE=patchutils/doc
FILE=patchutils.xml

TMP ?= /tmp

CVS=cvs
CVSFLAGS=

$(FILE):
	(cd $(TMP) && $(CVS) $(CVSFLAGS) -d:pserver:anoncvs@$(HOST):$(BASE) co $(MODULE))
	cp $(TMP)/$(MODULE)/$(FILE) .

clean:
	$(RM) $(FILE)
