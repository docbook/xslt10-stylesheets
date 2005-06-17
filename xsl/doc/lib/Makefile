include ../../../cvstools/Makefile.incl

STYLE=../../docsrc/lrefentry.xsl
VPATH=../../lib
XSLTOPT=

HTMLFILES = lib.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

clean:
	rm -f $(HTMLFILES)
