XSLT=../../../cvstools/saxon
XJPARSE=../../../cvstools/xjparse

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../pi

XMLFILES = pi.xml

all: $(XMLFILES)

clean:
	-echo nop

%.xml : %.xsl $(JSTYLE) ../../docsrc/legalnotice.xml
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@
