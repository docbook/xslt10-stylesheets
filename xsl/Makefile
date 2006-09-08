# $Id$

include ../cvstools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = doc docsrc install.sh

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = extensions/xsltproc doc/reference.txt$$ doc/reference.pdf$$

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES = doc

# list of pathname+URIs to test for catalog support
URILIST = \
.\ http://docbook.sourceforge.net/release/xsl/current/

DIRS=extensions common lib html fo manpages htmlhelp javahelp wordml

.PHONY: distrib clean doc docsrc xhtml

all: base xhtml

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

docsrc: base website slides
	$(MAKE) -C docsrc

doc: docsrc
	$(MAKE) -C doc

website:
	$(MAKE) -C ../website/xsl
	cp -pR ../website/xsl website

slides:
	$(MAKE) -C ../slides/xsl
	cp -pR ../slides/xsl slides
	cp -pR ../slides/graphics slides
	cp -pR ../slides/browser slides

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done
	$(MAKE) clean -C xhtml
	$(MAKE) clean -C doc
	$(MAKE) clean -C docsrc
	$(RM) -r website
	$(RM) -r slides

include ../releasetools/Targets.mk
