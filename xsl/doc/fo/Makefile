include ../../../cvstools/Makefile.incl

STYLE=../../docsrc/jrefhtml.xsl
VPATH=../../docsrc/fo
XSLTOPT=

HTMLFILES = param.html table.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

param.html: docparam.xml
	$(XSLT) $< ../../docsrc/clrefentry.xsl $(XSLTOPT)
	touch param.html

clean:
	$(RM) $(HTMLFILES)
