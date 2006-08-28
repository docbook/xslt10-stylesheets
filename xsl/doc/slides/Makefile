include ../../../cvstools/Makefile.incl

STYLE=../../docsrc/jrefhtml.xsl
VPATH=../../docsrc/slides/
XSLTOPT=

HTMLFILES = param.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

param.html: docparam.xml
	$(XSLT) $< ../../docsrc/clrefentry.xsl $(XSLTOPT)
	touch param.html

clean:
	$(RM) $(HTMLFILES)
