include ../../../cvstools/Makefile.incl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

all: param.xsl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

xml: param.xml

html: param.html

param.html: param.xml
	$(XSLT) $< ../../../xsl/docsrc/lrefentry.xsl $@

param.xml: param.xweb
	$(XSLT) $< ../../../xsl/profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../../../xsl/profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../../litprog/w2docbook.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

param.xsl: param.xweb
	$(XSLT) $< ../../../xsl/profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../../../xsl/profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../../litprog/xtangle.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

clean:
	rm -f param.xsl param.xml param.html

