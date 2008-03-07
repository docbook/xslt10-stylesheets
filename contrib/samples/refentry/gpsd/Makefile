BASEURL=svn://svn.berlios.de/gpsd/trunk
SUBMODULE=doc

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

SVN=svn
SVNFLAGS=

TMP ?= /tmp

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	(cd $(TMP) && $(SVN) $(SVNFLAGS) co $(BASEURL) $(SUBMODULE))
	mkdir $(SUBMODULE) && cp -pR $(TMP)/$(SUBMODULE)/*.xml $(SUBMODULE)

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
