include ../../../../cvstools/Makefile.incl

JSTYLE=../../../docsrc/xsl2jref.xsl
VPATH=../../../slides/html

XMLFILES = docparam.xml

all: $(XMLFILES)

clean:
	$(RM) $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

docparam.xml: ../../../slides/html/param.xsl
	$(MAKE) -C ../../../slides/html param.xml
	cp ../../../slides/html/param.xml docparam.xml
