STYLE=../jrefhtml.xsl
VPATH=../../docsrc/lib

HTMLFILES = lib.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	saxon $< $(STYLE) $@
