include ../../../cvstools/Makefile.incl
XSLT=saxon

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/common

HTMLFILES = common.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

clean:
	rm -f $(HTMLFILES)
