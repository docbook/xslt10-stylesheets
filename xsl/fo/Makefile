XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

all: titlepage.templates.xsl

titlepage.templates.xsl: titlepage.templates.xml ../template/titlepage.xsl
	$(XSLT) $< ../template/titlepage.xsl $@
