include ../../../cvstools/Makefile.incl

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/common
XSLTOPT=

HTMLFILES = common.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

clean:
	rm -f $(HTMLFILES)
