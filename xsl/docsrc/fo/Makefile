JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../fo

XMLFILES = param.xml table.xml

all: $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	saxon -6 $< $(JSTYLE) - output-file=$@
