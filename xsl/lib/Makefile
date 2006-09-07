include ../../cvstools/Makefile.incl

PARAMPROF=.lib.profiled
PARAMSTRIP=.lib.stripped
LREFENTRY=../tools/xsl/build/lrefentry.xsl

all: lib.xsl lib.xml

lib.html: lib.xml lib.xsl
	$(XSLT) $< $(LREFENTRY) $@

lib.xml: lib.xweb
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/w2docbook.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

lib.xsl: lib.xweb
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

clean:
	rm -f lib.html lib.xml lib.xsl
