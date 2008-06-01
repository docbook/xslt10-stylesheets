include $(DOCBOOK_SVN)/buildtools/Makefile.incl
all: profile-htmlhelp-common.xsl

profile-htmlhelp-common.xsl: htmlhelp-common.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) profile-htmlhelp-common.xsl
