include ../../../cvstools/Makefile.incl

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/fo

HTMLFILES = param.html table.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

param.html: param.xml
	$(XSLT) $< ../../docsrc/clrefentry.xsl

clean:
	rm -f $(HTMLFILES)
