XSLT=../../../cvstools/saxon
XJPARSE=../../../cvstools/xjparse

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../common

XMLFILES = common.xml

all: $(XMLFILES)

clean:
	rm -f $(XMLFILES)

%.xml : %.xsl $(JSTYLE) ../../docsrc/legalnotice.xml
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@
