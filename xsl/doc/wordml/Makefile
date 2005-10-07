include ../../../cvstools/Makefile.incl

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/wordml
XSLTOPT=

HTMLFILES = param.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

param.html: docparam.xml
	$(XSLT) $< ../../docsrc/clrefentry.xsl $(XSLTOPT)
	touch param.html

clean:
	rm -f *.html
