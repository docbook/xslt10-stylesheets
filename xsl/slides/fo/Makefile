include ../../../buildtools/Makefile.incl

TTLTEMPLATEXSL=$(DOCBOOK_SVN)/xsl/template/titlepage.xsl

all: plain-titlepage.xsl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

clean: 
	$(RM) plain-titlepage.xsl
