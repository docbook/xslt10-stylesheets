XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

PARAMPROF=.lib.profiled
PARAMSTRIP=.lib.stripped

all: lib.xsl lib.xml

lib.html: lib.xml lib.xsl
	$(XSLT) $< ../docsrc/lrefentry.xsl $@

lib.xml: lib.xweb
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/wdocbook.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

lib.xsl: lib.xweb
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)
