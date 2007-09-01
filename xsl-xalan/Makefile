# $Id: Makefile 7296 2007-08-28 09:16:40Z xmldoc $

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl-xalan

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

all: xalan27.jar javadoc

xalan27.jar: $(wildcard src/com/nwalsh/xalan/*.java)
	$(ANT) jar

javadoc:
	$(ANT) javadoc

clean:
	$(ANT) clean

include ../releasetools/Targets.mk
