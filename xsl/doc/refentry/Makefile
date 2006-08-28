include ../../../cvstools/Makefile.incl

STYLE=../../docsrc/jrefhtml.xsl
VPATH=../../docsrc/refentry
XSLTOPT=

HTMLFILES = refentry.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

clean:
	$(RM) $(HTMLFILES)
