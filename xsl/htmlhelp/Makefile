XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

all: profile-htmlhelp.xsl

profile-htmlhelp.xsl: htmlhelp.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@
