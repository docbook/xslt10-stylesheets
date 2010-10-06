include $(DOCBOOK_SVN)/buildtools/Makefile.incl

ANT = ant
ANT_OPTS = 

all: webhelp

webhelp: docsrc/readme.xml
	$(MAKE) -C ../xhtml
	$(XSLT) $< xsl/webhelp.xsl 
	$(ANT) index

# TODO: Still need to set things up for single pass profiling support.
#profile-webhelp-common.xsl: webhelp-common.xsl ../profiling/xsl2profile.xsl
#	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) -r doc/*

