include ../../../cvstools/Makefile.incl

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/pi

HTMLFILES = pi.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

pi.html: pi.xml
	$(XSLT) $< ../../docsrc/pirefentry.xsl

clean:
	rm -f *.html
