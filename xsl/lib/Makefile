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
ifeq ($(ADDNEWLINE),)
	$(XSLT) $(PARAMSTRIP) ../../litprog/w2docbook.xsl $@
else
	$(XSLT) $(PARAMSTRIP) ../../litprog/w2docbook.xsl $@.tmp
	$(XSLT) $@.tmp $(ADDNEWLINE) $@
	$(RM) $@.tmp
endif
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

lib.xsl: lib.xweb
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
ifeq ($(ADDNEWLINE),)
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
else
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@.tmp
	$(XSLT) $@.tmp $(ADDNEWLINE) $@
	$(RM) $@.tmp
endif
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

clean:
	rm -f lib.html lib.xml lib.xsl
