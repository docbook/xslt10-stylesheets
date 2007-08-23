include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl-java

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS =

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = xsltproc saxon65 xalan27

ANT = ant
ANT_OPTS =

all: jars

jars: saxon65.jar xalan27.jar

saxon65.jar: $(wildcard saxon65/src/com/nwalsh/saxon/*.java)
	cd saxon65 && $(ANT) jar
	cp saxon65/dist/saxon65.jar .

xalan27.jar: $(wildcard xalan27/src/com/nwalsh/xalan/*.java)
	cd xalan27 && $(ANT) jar
	cp xalan27/dist/xalan27.jar .

clean:
	cd saxon65 && $(ANT) clean
	cd xalan27 && $(ANT) clean
	$(RM) *.jar

include ../releasetools/Targets.mk
