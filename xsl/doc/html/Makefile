include ../../../cvstools/Makefile.incl
XSLT=saxon

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/html

HTMLFILES = param.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

param.html: param.xml
	$(XSLT) $< ../../docsrc/clrefentry.xsl

clean:
	rm -f *.html
