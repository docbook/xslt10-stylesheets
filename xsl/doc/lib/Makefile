include ../../../cvstools/Makefile.incl

STYLE=../../docsrc/lrefentry.xsl
VPATH=../../lib

HTMLFILES = lib.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

clean:
	rm -f $(HTMLFILES)
