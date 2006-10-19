include ../../cvstools/Makefile.incl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

all: param.xsl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

param.xsl: param.xweb
	$(XSLT) $< ../../xsl/profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../../xsl/profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
ifeq ($(ADDNEWLINE),)
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
else
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@.tmp
	$(XSLT) $@.tmp $(ADDNEWLINE) $@
	$(RM) $@.tmp
endif
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

clean:
	$(RM) param.xsl

