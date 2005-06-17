include ../../../cvstools/Makefile.incl

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../html

XMLFILES = docparam.xml

all: $(XMLFILES)

clean:
	$(RM) $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

docparam.xml: ../../html/param.xsl
	$(MAKE) -C ../../html param.xml
	cp ../../html/param.xml docparam.xml
