# $Id: Makefile 7424 2007-09-01 10:59:59Z xmldoc $

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl-webhelpindexer

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS =

# value of ZIP_DEPENDS is a space-separated list of any targets
# for this distro's "zip" target to depend on
ZIP_DEPENDS =

# value of INSTALL_DEPENDS is a space-separated list of any
# targets for this distro's "install" target to depend on
INSTALL_DEPENDS = release tag

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = \
  RELEASE-NOTES-PARTIAL.txt \

ANT = ant
ANT_OPTS =

all: webhelpindexer.jar

webhelpindexer.jar: $(wildcard src/)
	$(ANT) jar

javadoc:
	$(ANT) javadoc

clean:
	$(ANT) clean

include ../releasetools/Targets.mk
