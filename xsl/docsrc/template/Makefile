XSLT=../../../cvstools/saxon
XJPARSE=../../../cvstools/xjparse

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../template

XMLFILES = titlepage.xml

all: $(XMLFILES)

clean:
	rm -f $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@
