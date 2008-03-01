URL=svn://svn.debian.org/svn/pkg-shadow/upstream/trunk/man
SUBMODULE=man

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

SVN=svn
SVNFLAGS=

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	$(SVN) co $(SVNFLAGS) $(URL)

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
