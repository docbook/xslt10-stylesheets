BASEURL=svn://svn.debian.org/pkg-pam/trunk/pam/Linux-PAM/doc
SUBMODULE=man

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

SVN=svn
SVNFLAGS=

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	$(SVN) $(SVNFLAGS) co $(BASEURL)/$(SUBMODULE)

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
