XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

all: profile-htmlhelp-common.xsl

profile-htmlhelp-common.xsl: htmlhelp-common.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@
