include ../../buildtools/Makefile.incl
all: profile-javahelp.xsl

profile-javahelp.xsl: javahelp.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) profile-javahelp.xsl
