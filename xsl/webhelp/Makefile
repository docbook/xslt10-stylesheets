include $(DOCBOOK_SVN)/buildtools/Makefile.incl

ANT = ant
ANT_OPTS = 
XSLTPROC_OPTS="--stringparam webhelp.include.search.tab true --stringparam webhelp.indexer.language en --stringparam branding docbook  --stringparam  brandname DocBook"
XSLTSAXON_OPTS=webhelp.include.search.tab="true" webhelp.indexer.language="en" branding="docbook" brandname="DocBook"
XSLTXALAN_OPTS="-param webhelp.include.search.tab true -param webhelp.indexer.language en -param branding docbook  -param  brandname DocBook"

all: webhelp

webhelp: docsrc/readme.xml
	$(MAKE) -C ../xhtml
ifeq ($(XSLTENGINE),saxon)
	$(XSLT) $< xsl/webhelp.xsl ${XSLTSAXON_OPTS}
else ifeq ($(XSLTENGINE),xalan)
	$(XSLT) $< xsl/webhelp.xsl ${XSLTXALAN_OPTS}
else
	$(XSLT) ${XSLTPROC_OPTS} $< xsl/webhelp.xsl	
endif 
	$(ANT) index

# TODO: Still need to set things up for single pass profiling support.
#profile-webhelp-common.xsl: webhelp-common.xsl ../profiling/xsl2profile.xsl
#	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) -r docs/*

