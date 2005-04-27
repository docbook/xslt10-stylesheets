# $Id$

include ../cvstools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO = slides

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = doc demo tests

# value of DISTRIB_EXCLUDES is a space-separated list of any file
# or directory names (regular expressions OK) that should be
# excluded from the zip file and tarball for the release
DISTRIB_EXCLUDES = /tests$$

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES = demo

# to make sure that executable bit is retained after packaging,
# you need to explicitly list any special executable files here
DISTRIB_EXECUTABLES =

# list of pathname+URIs to test for catalog support
URILIST = \
	schema/dtd/slides.dtd\ http://docbook.sourceforge.net/release/slides/3.4/schema/dtd/slides.dtd \
	schema/dtd/slides-full.dtd\ http://docbook.sourceforge.net/release/slides/3.4/schema/dtd/slides-full.dtd \
	schema/dtd/slides.dtd\ http://docbook.sourceforge.net/release/slides/current/schema/dtd/slides.dtd \
	schema/dtd/slides-full.dtd\ http://docbook.sourceforge.net/release/slides/current/schema/dtd/slides-full.dtd \
	xsl/\ http://docbook.sourceforge.net/release/slides/3.4.0/xsl/ \
	xsl/\ http://docbook.sourceforge.net/release/slides/current/xsl/

.PHONY: doc demo tests

all: base

base:
	$(MAKE) -C schema
	$(MAKE) -C xsl

check:
	$(XJPARSE) tests/test.xml
	$(XJPARSE) tests/testcust.xml
	$(XJPARSE) tests/testfull.xml

clean:
	$(MAKE) -C doc clean
	$(MAKE) -C demo clean
	$(MAKE) -C schema clean
	$(MAKE) -C tests clean
	$(MAKE) -C xsl clean

maintainer-clean: clean
	$(MAKE) -C schema maintainer-clean

demo:
	make -C demo

doc:
	make -C doc

tests:
	make -C tests

include ../releasetools/Targets.mk
