include ../../../buildtools/Makefile.incl

PARAMBASE=param
XSLFILES=param.xsl
ALLTARGETS=$(XSLFILES) plain-titlepage.xsl
PROFILECONDITION=slides-fo
TTLTEMPLATEXSL=$(DOCBOOK_SVN)/xsl/template/titlepage.xsl
CLEANTARGETS=titlepage-clean

include ../../Makefile.incl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

titlepage-clean:
	$(RM) plain-titlepage.xsl
