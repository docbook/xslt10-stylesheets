include ../../../buildtools/Makefile.incl

PARAMBASE=param
XSLFILES=param.xsl
ALLTARGETS=$(XSLFILES) plain-titlepage.xsl
PROFILECONDITION=slides-xhtml
TTLTEMPLATEXSL=../../template/titlepage.xsl
CLEANTARGETS=titlepage-clean
NESTLEVEL=../
TARGETNS=http://www.w3.org/1999/xhtml

include ../../Makefile.incl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@ ns=$(TARGETNS)

titlepage-clean:
	$(RM) plain-titlepage.xsl

