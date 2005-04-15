# $Id$

include ../cvstools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO = website

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = example RELEASE-NOTES.txt

# value of DISTRIB_EXCLUDES is a space-separated list of any file
# or directory names (regular expressions OK) that should be
# excluded from the zip file and tarball for the release
DISTRIB_EXCLUDES = /tests$$

# to make sure that executable bit is retained after packaging,
# you need to explicitly list any executable files here
EXECUTABLES = install.sh

.PHONY : distrib clean example

all:
	$(MAKE) -C schema all
	$(MAKE) -C extensions all

example:
	$(MAKE) -C example DOCBOOK_WEBSITE=$(WEBSITEROOT)

clean:
	$(MAKE) -C extensions clean
	$(MAKE) -C example clean
	$(MAKE) -C example MAKENONTAB=1 clean

realclean: clean
	$(MAKE) -C extensions realclean
	$(MAKE) -C example realclean

include ../releasetools/Targets.mk
