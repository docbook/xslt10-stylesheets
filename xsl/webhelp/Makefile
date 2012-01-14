include $(DOCBOOK_SVN)/buildtools/Makefile.incl

ANT = ant
ANT_OPTS = 

all: webhelp

webhelp: docsrc/readme.xml
	$(MAKE) -C ../xhtml
	$(XSLT) $< ../profiling/profile.xsl webhelp-temp.xml 
	$(XSLT) webhelp-temp.xml xsl/webhelp.xsl webhelp.include.search.tab="true" webhelp.indexer.language="en" branding="docbook" brandname="DocBook"
	$(ANT) index

clean:
	$(RM) -r docs/*

