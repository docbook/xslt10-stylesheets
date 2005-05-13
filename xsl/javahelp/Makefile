XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

all: profile-javahelp.xsl

profile-javahelp.xsl: javahelp.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	rm -f profile-javahelp.xsl
