XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

include Makefile.param

all: titlepage.templates.xsl param.xsl

param.html: param.xml
	$(XSLT) $< ../docsrc/lrefentry.xsl $@

param.xml: param.xweb $(PARAMS)
	../../cvstools/paramchk -m Makefile.param $<
	$(XSLT) $< ../../litprog/wdocbook.xsl $@

param.xsl: param.xweb $(PARAMS)
	../../cvstools/paramchk -m Makefile.param $<
	$(XSLT) $< ../../litprog/xtangle.xsl $@

titlepage.templates.xsl: titlepage.templates.xml ../template/titlepage.xsl
	$(XSLT) $< ../template/titlepage.xsl $@

Makefile.param:
	../../cvstools/paramchk -m $@ param.xweb
