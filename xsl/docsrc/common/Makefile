JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../common

XMLFILES = common.xml

all: $(XMLFILES)

%.xml : %.xsl $(JSTYLE) ../../docsrc/legalnotice.xml
	saxon -6 $< $(JSTYLE) /dev/null output-file=$@
	xnsgmls -E 5 -sv -c /share/doctypes/catalog $@
