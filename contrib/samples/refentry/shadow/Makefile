URL=svn://svn.debian.org/svn/pkg-shadow/upstream/trunk
SUBMODULE=man

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

SVN=svn
SVNFLAGS=

all: $(SUBMODULE)

$(TMP)/shadow/man:
	$(RM) -r $(TMP)/shadow
	cd $(TMP) \
	  && $(SVN) co $(SVNFLAGS) $(URL) shadow \
	  && cd $(TMP)/shadow \
	  && ./autogen.sh \
	  && cd $(TMP)/shadow/man \
	  && make
	
$(SUBMODULE): $(TMP)/shadow/man
	mv $< $@

clean:
	$(RM) -r $(SUBMODULE)
