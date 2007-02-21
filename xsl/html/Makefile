include ../../cvstools/Makefile.incl

XSLFILES=param.xsl profile-docbook.xsl titlepage.templates.xsl \
  profile-chunk-code.xsl
ALLTARGETS=$(XSLFILES)
PROFILECONDITION=html

include ../Makefile.incl

profile-chunk-code.xsl: chunk-code.xsl $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl
	$(XSLT) $< $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl $@
