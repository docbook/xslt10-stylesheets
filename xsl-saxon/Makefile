# $Id$

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl-saxon

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

all: saxon65.jar javadoc

saxon65.jar: $(wildcard src/com/nwalsh/saxon/*.java)
	$(ANT) jar

javadoc:
	$(ANT) javadoc

clean:
	$(ANT) clean

include ../releasetools/Targets.mk
