include ../../../cvstools/Makefile.incl
XSLT=xt

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/fo

HTMLFILES = param.html table.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

clean:
	rm -f $(HTMLFILES)
