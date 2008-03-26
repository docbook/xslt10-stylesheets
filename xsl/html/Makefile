include ../../buildtools/Makefile.incl

PARAMBASE=param
XSLFILES=param.xsl profile-docbook.xsl profile-chunk-code.xsl
ALLTARGETS=$(XSLFILES) titlepage.templates.xsl
PROFILECONDITION=html

include ../Makefile.incl

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
# Java under Cygwin doesn't grok Cygwin absolute paths, so use
# relative path instead
profile-chunk-code.xsl: chunk-code.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@
else
profile-chunk-code.xsl: chunk-code.xsl $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl
	$(XSLT) $< $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl $@
endif
else
profile-chunk-code.xsl: chunk-code.xsl $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl
	$(XSLT) $< $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl $@
endif
