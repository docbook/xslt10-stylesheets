JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../lib

XMLFILES = lib.xml

all: $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	saxon -6 $< $(JSTYLE) /dev/null output-file=$@
