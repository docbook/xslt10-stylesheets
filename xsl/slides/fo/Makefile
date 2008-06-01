include $(DOCBOOK_SVN)/buildtools/Makefile.incl

PARAMBASE=param
XSLFILES=param.xsl
ALLTARGETS=$(XSLFILES) plain-titlepage.xsl
PROFILECONDITION=slides-fo
TTLTEMPLATEXSL=../../template/titlepage.xsl
CLEANTARGETS=titlepage-clean
NESTLEVEL=../

include ../../Makefile.incl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

titlepage-clean:
	$(RM) plain-titlepage.xsl
