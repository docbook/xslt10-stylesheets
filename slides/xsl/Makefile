include ../../cvstools/Makefile.incl
TTLTEMPLATEXSL=/sourceforge/docbook/xsl/template/titlepage.xsl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

all: titlepage-fo-plain.xsl param.xsl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

xml: param.xml

html: param.html

param.html: param.xml
	$(XSLT) $< ../../xsl/docsrc/lrefentry.xsl $@

param.xml: param.xweb
	$(XSLT) $< ../../xsl/profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../../xsl/profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/wdocbook.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

param.xsl: param.xweb
	$(XSLT) $< ../../xsl/profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../../xsl/profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

clean:
	rm -f titlepage-fo-plain.xsl
