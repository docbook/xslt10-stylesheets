STYLE=../jrefhtml.xsl
VPATH=../../docsrc/fo

HTMLFILES = param.html table.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	saxon $< $(STYLE) $@
