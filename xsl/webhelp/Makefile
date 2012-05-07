include $(DOCBOOK_SVN)/buildtools/Makefile.incl

ANT = ant
ANT_OPTS = 

all: webhelp

webhelp: docsrc/readme.xml
	$(MAKE) -C ../xhtml
ifeq ($(XSLTENGINE),xsltproc)
	$(XSLT) --xinclude $< ../profiling/profile.xsl webhelp-temp.xml 
else
	$(XSLT) $< ../profiling/profile.xsl webhelp-temp.xml 
endif
	$(XSLT) webhelp-temp.xml xsl/webhelp.xsl
	rm webhelp-temp.xml
	$(ANT) index
clean:
	$(RM) -r docs/*

