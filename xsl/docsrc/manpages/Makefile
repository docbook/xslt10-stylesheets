XSLT=../../../cvstools/saxon
XJPARSE=../../../cvstools/xjparse

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../manpages

XMLFILES = param.xml

all: $(XMLFILES)

clean:
	rm -f $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

param.xml: param.xweb
	$(MAKE) -C ../../manpages param.xml
	cp ../../manpages/param.xml .
