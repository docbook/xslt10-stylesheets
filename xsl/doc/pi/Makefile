include ../../../releasetools/Variables.mk
VPATH=../../docsrc/pi
HTMLFILES = common.html
include ../Makefile.incl

common.html: pi.xml
	$(XSLT) $< $(PIREFENTRY) $(XSLTOPT)
