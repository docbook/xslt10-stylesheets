include ../../../cvstools/Makefile.incl
XSLT=xt

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/common

HTMLFILES = common.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

clean:
	rm -f $(HTMLFILES)
