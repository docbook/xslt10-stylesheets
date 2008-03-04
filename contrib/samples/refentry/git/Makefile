BASEURL=git://git.kernel.org/pub/scm/git/git.git
SUBMODULE=Documentation

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

GIT=git
GITFLAGS=

all: $(SUBMODULE)

$(SUBMODULE):
	(cd $(TMP) && $(RM) -r $(TMP)/git && $(GIT) $(GITFLAGS) clone $(BASEURL))
	$(MAKE) -C $(TMP)/git/$(SUBMODULE) man
	cp -pR $(TMP)/git/$(SUBMODULE) .

clean:
	$(RM) -r $(SUBMODULE)
