# $Id$

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = gentext doc docsrc install.sh RELEASE-NOTES.txt RELEASE-NOTES.pdf

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = gentext/$$ extensions/xsltproc doc/reference.txt$$ reference.txt.html$$ doc/reference.fo$$ doc/reference.pdf$$ tools/xsl xhtml/html2xhtml.xsl

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES = doc

# list of pathname+URIs to test for catalog support
URILIST = \
.\ http://docbook.sourceforge.net/release/xsl/current/

DIRS=common lib html fo manpages htmlhelp javahelp eclipse roundtrip slides website

.PHONY: distrib clean doc docsrc xhtml

all: base xhtml
# If you're annoyed about getting the reminder that it's possible
# to use xsltproc to build, delete the following conditional from
# this makefile.
ifeq (,$(findstring xsltproc,$(XSLT)))
	@echo
	@echo "-----------------------------------------------------------------"
	@echo "   To build using xsltproc, run make as follows:"
	@echo "     make XSLT=\"\$$DOCBOOK_SVN/buildtools/xslt -xsltproc\""
	@echo "-----------------------------------------------------------------"
endif

base: litprog
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

litprog:
	$(MAKE) -C ../litprog

xhtml:
	$(MAKE) -C xhtml

docsrc: base 
	$(MAKE) -C docsrc

doc: docsrc
	$(MAKE) -C doc RELVER=$(RELVER)

extensions:
	make -C ../xsl-java
	cp -pR ../xsl-java .

gentext:
	cp -pR ../gentext .

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done
	$(RM) -r extensions
	$(RM) -r gentext
	$(MAKE) clean -C xhtml
	$(MAKE) clean -C doc
	$(MAKE) clean -C docsrc

include ../releasetools/Targets.mk
include ../releasetools/db5.mk
