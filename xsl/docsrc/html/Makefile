JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../html

XMLFILES = param.xml ebnf.xml

all: $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	saxon -6 $< $(JSTYLE) /dev/null output-file=$@
