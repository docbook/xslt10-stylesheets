BASEURL=svn://svn.debian.org/svn/pkg-java/trunk/saxonb/debian
SUBMODULE=manpages

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

SVN=svn
SVNFLAGS=

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	(cd $(TMP) && $(SVN) $(SVNFLAGS) co $(BASEURL)/$(SUBMODULE))
	$(RM) $(TMP)/$(SUBMODULE)/Makefile
	cp -pR $(TMP)/$(SUBMODULE) .

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
