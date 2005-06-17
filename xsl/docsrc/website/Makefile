include ../../../cvstools/Makefile.incl

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../../website/xsl

XMLFILES = docparam.xml

all: $(XMLFILES)

clean:
	$(RM) $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

docparam.xml: ../../../website/xsl/param.xsl
	$(MAKE) -C ../../../website/xsl param.xml
	cp ../../../website/xsl/param.xml docparam.xml
