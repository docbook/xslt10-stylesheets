all: titlepage.templates.xsl

titlepage.templates.xsl: titlepage.templates.xml ../template/titlepage.xsl
	saxon $< ../template/titlepage.xsl $@
