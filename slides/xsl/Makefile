include ../../cvstools/Makefile.incl
TTLTEMPLATEXSL=/sourceforge/docbook/xsl/template/titlepage.xsl

all: titlepage-fo-plain.xsl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

clean:
	rm -f titlepage-fo-plain.xsl
