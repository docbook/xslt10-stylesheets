XSLT=../../buildtools/saxon
XJPARSE=../../buildtools/xjparse

all: profile-eclipse.xsl

profile-eclipse.xsl: eclipse.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	rm -f profile-eclipse.xsl
