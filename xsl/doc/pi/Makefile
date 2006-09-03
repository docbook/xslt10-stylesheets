include ../../../releasetools/Variables.mk
VPATH=../../docsrc/pi
HTMLFILES = pi.html
include ../Makefile.incl

pi.html: pi.xml
	$(XSLT) $< ../../docsrc/pirefentry.xsl $(XSLTOPT)
	touch pi.html
