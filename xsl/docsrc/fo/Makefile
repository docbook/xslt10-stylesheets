XSLT=../../../cvstools/saxon
XJPARSE=../../../cvstools/xjparse

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../fo

XMLFILES = param.xml table.xml

all: $(XMLFILES)

clean:
	$(RM) $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

param.xml: ../../fo/param.xsl
	$(MAKE) -C ../../fo param.xml
	cp ../../fo/param.xml .
