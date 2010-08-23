include $(DOCBOOK_SVN)/buildtools/Makefile.incl

ANT = ant
ANT_OPTS = 

all: build-indexer webhelp

build-indexer: 
	$(ANT) build-indexer

webhelp: docsrc/readme.xml
	# Doing this outside of Ant because I was getting a strange error on Ubuntu. 
	# and I didn't have time to debug.
	$(XSLT) $< xsl/webhelp.xsl 
	$(ANT) index

#profile-webhelp-common.xsl: webhelp-common.xsl ../profiling/xsl2profile.xsl
#	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) -r doc/* indexer/lib/nw-cms.jar

