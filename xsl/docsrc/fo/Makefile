XSLT=../../../cvstools/saxon
XJPARSE=../../../cvstools/xjparse

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../fo

XMLFILES = param.xml table.xml

all: $(XMLFILES)

clean:
	rm -f $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

param.xml: param.xweb
	$(MAKE) -C ../../fo param.xml
	cp ../../fo/param.xml .
