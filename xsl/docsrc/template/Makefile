JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../template

XMLFILES = titlepage.xml

all: $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	saxon -6 $< $(JSTYLE) /dev/null output-file=$@
	xnsgmls -E 5 -sv -c /share/doctypes/catalog $@
