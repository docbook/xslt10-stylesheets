include ../../../cvstools/Makefile.incl
TTLTEMPLATEXSL=../../../xsl/template/titlepage.xsl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

all: plain-titlepage.xsl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

clean:
	rm -f plain-titlepage.xsl
