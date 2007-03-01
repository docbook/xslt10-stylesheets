# $Id$

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO = website

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = example

# value of DISTRIB_EXCLUDES is a space-separated list of any file
# or directory names (regular expressions OK) that should be
# excluded from the zip file and tarball for the release
DISTRIB_EXCLUDES = /tests$$

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES =

# to make sure that executable bit is retained after packaging,
# you need to explicitly list any executable files here
DISTRIB_EXECUTABLES =

# list of pathname+URIs to test for catalog support
URILIST = \
	schema/dtd/website.dtd\ http://docbook.sourceforge.net/release/website/2.6/schema/dtd/website.dtd \
	schema/dtd/website-full.dtd\ http://docbook.sourceforge.net/release/website/2.6/schema/dtd/website-full.dtd \
	schema/dtd/website.dtd\ http://docbook.sourceforge.net/release/website/current/schema/dtd/website.dtd \
	schema/dtd/website-full.dtd\ http://docbook.sourceforge.net/release/website/current/schema/dtd/website-full.dtd \
	xsl/\ http://docbook.sourceforge.net/release/website/current/xsl/

.PHONY : distrib clean example

all:
	$(MAKE) -C schema all
	$(MAKE) -C extensions all
	$(MAKE) -C xsl all

example:
	$(MAKE) -C example DOCBOOK_WEBSITE=$(WEBSITEROOT)

clean:
	$(MAKE) -C extensions clean
	$(MAKE) -C schema clean
	$(MAKE) -C example clean
	$(MAKE) -C example MAKENONTAB=1 clean
	$(MAKE) -C xsl clean

realclean: clean
	$(MAKE) -C extensions realclean
	$(MAKE) -C schema realclean
	$(MAKE) -C example realclean

include ../releasetools/Targets.mk
