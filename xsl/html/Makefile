XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

include Makefile.param

all: titlepage.templates.xsl param.xsl \
     profile-docbook.xsl profile-chunk.xsl profile-onechunk.xsl

xml: param.xml

html: param.html

param.html: param.xml
	../../cvstools/paramchk -m Makefile.param $<
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
	make

profile-docbook.xsl:
	$(XSLT) docbook.xsl ../profiling/xsl2profile.xsl $@

profile-chunk.xsl:
	$(XSLT) chunk.xsl ../profiling/xsl2profile.xsl $@

profile-onechunk.xsl:
	$(XSLT) onechunk.xsl ../profiling/xsl2profile.xsl $@
