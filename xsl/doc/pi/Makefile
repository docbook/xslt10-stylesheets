include ../../../releasetools/Variables.mk
VPATH=../../docsrc/pi
HTMLFILES = pi.html
include ../Makefile.incl

pi.html: pi.xml
	$(XSLT) $< $(PIREFENTRY) $(XSLTOPT)
	touch $@
