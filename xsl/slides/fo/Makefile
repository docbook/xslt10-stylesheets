include ../../../buildtools/Makefile.incl

PARAMBASE=param
XSLFILES=param.xsl plain-titlepage.xsl
ALLTARGETS=$(XSLFILES)
PROFILECONDITION=slides-fo
TTLTEMPLATEXSL=$(DOCBOOK_SVN)/xsl/template/titlepage.xsl
CLEANTARGETS=titlepage-clean

include ../../Makefile.incl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

titlepage-clean:
	$(RM) plain-titlepage.xsl
