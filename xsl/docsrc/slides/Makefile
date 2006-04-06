include ../../../cvstools/Makefile.incl

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../slides

XMLFILES = docparam.xml

all: $(XMLFILES)

clean:
	$(RM) $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

docparam.xml: ../../slides/param.xsl
	$(MAKE) -C ../../slides param.xml
	cp ../../slides/param.xml docparam.xml
