include ../../../cvstools/Makefile.incl
XSLT=saxon

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/fo

HTMLFILES = param.html table.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

param.html: param.xml
	$(XSLT) $< ../../docsrc/lrefentry.xsl $@

clean:
	rm -f $(HTMLFILES)
