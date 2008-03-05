BASEURL=svn://svn.debian.org/debian-xml-sgml/packages/docbook-xsl/trunk/debian
SUBMODULE=examples

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

SVN=svn
SVNFLAGS=

all: $(SUBMODULE)

$(SUBMODULE):
	$(SVN) $(SVNFLAGS) co $(BASEURL)/$(SUBMODULE)

clean:
	$(RM) -r $(SUBMODULE)
