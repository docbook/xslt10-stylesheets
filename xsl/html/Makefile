XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

all: titlepage.templates.xsl param.xsl

xml: param.xml

html: param.html

param.html: param.xml
	$(XSLT) $< ../docsrc/lrefentry.xsl $@

param.xml: param.xweb
	$(XSLT) $< ../../litprog/wdocbook.xsl $@

param.xsl: param.xweb
	$(XSLT) $< ../../litprog/xtangle.xsl $@

titlepage.templates.xsl: titlepage.templates.xml ../template/titlepage.xsl
	$(XSLT) $< ../template/titlepage.xsl $@
