include ../../../cvstools/Makefile.incl

STYLE=../../docsrc/jrefhtml.xsl
VPATH=../../docsrc/pi
XSLTOPT=

HTMLFILES = pi.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

pi.html: pi.xml
	$(XSLT) $< ../../docsrc/pirefentry.xsl $(XSLTOPT)
	touch pi.html

clean:
	rm -f *.html
