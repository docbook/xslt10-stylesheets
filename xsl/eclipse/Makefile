include $(DOCBOOK_SVN)/buildtools/Makefile.incl
all: profile-eclipse.xsl

profile-eclipse.xsl: eclipse.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) profile-eclipse.xsl
