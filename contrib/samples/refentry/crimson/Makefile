HOST=cvs.seul.org
BASE=/home/cvspsrv/cvsroot
MODULE=games/crimson/doc
FILES=bi2cf.xml cfed.xml comet.xml crimson.xml

TMP ?= /tmp

CVS=cvs
CVSFLAGS=

$(FILES):
	@echo Password is \"guest\"
	@echo
	$(CVS) $(CVSFLAGS)-d:pserver:anoncvs@$(HOST):$(BASE) login
	(cd $(TMP) && $(CVS) $(CVSFLAGS) -d:pserver:anoncvs@$(HOST):$(BASE) co $(MODULE))
	for file in $(FILES); do cp $(TMP)/$(MODULE)/$$file .; done

clean:
	$(RM) $(FILES)
