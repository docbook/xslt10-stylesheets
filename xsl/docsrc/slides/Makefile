include ../../../cvstools/Makefile.incl

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../../slides/xsl

XMLFILES = docparam.xml

all: $(XMLFILES)

clean:
	$(RM) $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

docparam.xml: ../../../slides/xsl/param.xsl
	$(MAKE) -C ../../../slides/xsl param.xml
	cp ../../../slides/xsl/param.xml docparam.xml
