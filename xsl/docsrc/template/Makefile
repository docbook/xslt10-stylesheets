XSLT=../../../cvstools/saxon
XJPARSE=../../../cvstools/xjparse

JSTYLE=../../docsrc/xsl2jref.xsl
TOREFSECT1=../../docsrc/torefsect1.xsl
VPATH=../../template

XMLFILES = titlepage.xml titlepage.refsect1.xml

all: $(XMLFILES)

clean:
	rm -f $(XMLFILES)

%.refsect1.xml: %.xml $(TOREFSECT1)
	$(XSLT) $< $(TOREFSECT1) $@

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@
