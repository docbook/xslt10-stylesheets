include ../../../cvstools/Makefile.incl

STYLE=../jrefhtml.xsl
VPATH=../../docsrc/fo

HTMLFILES = param.html table.html
PARAMFILES = $(foreach file,$(basename $(shell find ../../params/*.xml)),$(file).html)

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

param.html: param.xml
	$(XSLT) $< ../../docsrc/clrefentry.xsl

clean:
	rm -f $(HTMLFILES)
	rm -f $(PARAMFILES)
