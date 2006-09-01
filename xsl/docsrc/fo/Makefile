include ../../../cvstools/Makefile.incl

JSTYLE=../../docsrc/xsl2jref.xsl
TOREFSECT1=../../docsrc/torefsect1.xsl
VPATH=../../fo

XMLFILES = docparam.xml table.xml table.refsect1.xml

all: $(XMLFILES)

clean:
	$(RM) $(XMLFILES)

%.refsect1.xml: %.xml $(TOREFSECT1)
	$(XSLT) $< $(TOREFSECT1) $@

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

docparam.xml: ../../fo/param.xsl
	$(MAKE) -C ../../fo param.xml
	cp ../../fo/param.xml docparam.xml
