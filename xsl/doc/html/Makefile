STYLE=../jrefhtml.xsl
VPATH=../../docsrc/html

HTMLFILES = param.html ebnf.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	saxon $< $(STYLE) $@
