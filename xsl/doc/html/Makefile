include ../../../cvstools/Makefile.incl
XSLT=xt

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/html

HTMLFILES = param.html ebnf.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

clean:
	rm -f $(HTMLFILES)
