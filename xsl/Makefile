# $Id$

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

# The -E0 switch on xjparse gets passed on to the XML Commons
# resolver and causes all error message from the resolver to be
# suppressed. The -w switch causes the resolver to just do a
# well-formedness check instead of a validity check.
XJPARSEFLAGS=-E 0 -w

DISTRO=xsl

# value of DISTRIB_CHANGELOG_INCLUDES is a space-separated list of
# any other top-level modules from which to log changes in the
# NEWS and RELEASE-NOTES.* files for this distro
DISTRIB_CHANGELOG_INCLUDES = gentext xsl-saxon xsl-xalan

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = doc docsrc install.sh RELEASE-NOTES.txt extensions

# value of RELEASE_DEPENDS is a space-separated list of any
# targets for this distro's "release" target to depend on
RELEASE_DEPENDS = smoketest RELEASE-NOTES.pdf

# value of INSTALL_DEPENDS is a space-separated list of any
# targets for this distro's "install" target to depend on
INSTALL_DEPENDS = release tag

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = \
  reference.txt.html$$ \
  doc/reference.txt$$ \
  doc/reference.fo$$ \
  doc/reference.pdf$$ \
  doc/HTML.manifest$$ \
  tools/xsl \
  xhtml/html2xhtml.xsl$$ \
  README.BUILD \
  RELEASE-NOTES-PARTIAL.txt \
  .param.dbkns \
  .param.stripped \
  .param.xmlid \
  .lib.dbkns \
  .lib.stripped \
  .lib.xmlid

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES = doc

# list of pathname+URIs to test for catalog support
URILIST = \
.\ http://docbook.sourceforge.net/release/xsl/current/

DIRS=common lib html fo manpages htmlhelp javahelp eclipse roundtrip slides website

NORMAL_STYLES=fo/docbook.xsl html/docbook.xsl xhtml/docbook.xsl
NORMAL_PROFILE_STYLES=fo/profile-docbook.xsl html/profile-docbook.xsl xhtml/profile-docbook.xsl
HELP_STYLES=htmlhelp/htmlhelp.xsl javahelp/javahelp.xsl eclipse/eclipse.xsl
CHUNK_STYLES=html/chunk.xsl html/onechunk.xsl xhtml/chunk.xsl xhtml/onechunk.xsl
CHUNK_PROFILE_STYLES=html/profile-chunk.xsl html/profile-onechunk.xsl xhtml/profile-chunk.xsl xhtml/profile-onechunk.xsl
HELP_PROFILE_STYLES=htmlhelp/profile-htmlhelp.xsl eclipse/profile-eclipse.xsl javahelp/profile-javahelp.xsl
MAN_STYLES=manpages/docbook.xsl
MAN_PROFILE_STYLES=manpages/profile-docbook.xsl

ROUNDTRIP_STYLES=roundtrip/dbk2ooo.xsl roundtrip/dbk2pages.xsl roundtrip/dbk2wordml.xsl
SLIDES_STYLES=slides/html/default.xsl slides/xhtml/default.xsl slides/fo/plain.xsl
WEBSITE_STYLES=website/website.xsl
WEBSITE_CHUNK_STYLES=website/chunk-website.xsl

.PHONY: distrib clean doc docsrc xhtml

all: base xhtml
# If you're annoyed about getting the reminder that it's possible
# to use xsltproc to build, delete the following conditional from
# this makefile.
ifeq (,$(findstring xsltproc,$(XSLT)))
	@echo
	@echo "-----------------------------------------------------------------"
	@echo "   To build using xsltproc, run make as follows:"
	@echo "     make XSLTENGINE=\"xsltproc\""
	@echo "-----------------------------------------------------------------"
endif

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

xhtml:
	$(MAKE) -C xhtml

docsrc: base 
	$(MAKE) -C docsrc

doc: docsrc
	$(MAKE) -C doc RELVER=$(RELVER)

extensions: ../xsl-saxon/saxon65.jar ../xsl-xalan/xalan27.jar
	if [ ! -d $@ ]; then mkdir $@; fi
	cp -p $^ $@

../xsl-saxon/saxon65.jar: $(wildcard ../xsl-saxon/src/com/nwalsh/saxon/*.java) 
	$(MAKE) -C $(dir $@)

../xsl-xalan/xalan27.jar: $(wildcard ../xsl-xalan/src/com/nwalsh/xalan/*.java) 
	$(MAKE) -C $(dir $@)

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done
	$(RM) -r extensions
	$(MAKE) clean -C xhtml
	$(MAKE) clean -C doc
	$(MAKE) clean -C docsrc

include Makefile.tests
include ../releasetools/Targets.mk
include ../releasetools/xslns.mk
