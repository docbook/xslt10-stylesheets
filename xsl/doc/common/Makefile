STYLE=../jrefhtml.xsl
VPATH=../../docsrc/common

HTMLFILES = common.html

all: $(HTMLFILES)

%.html : %.xml $(STYLE)
	saxon $< $(STYLE) $@
