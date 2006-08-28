include ../../../cvstools/Makefile.incl

STYLE=../../docsrc/jrefhtml.xsl
VPATH=../../docsrc/template
XSLTOPT=

HTMLFILES = titlepage.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

clean:
	rm -f $(HTMLFILES)
