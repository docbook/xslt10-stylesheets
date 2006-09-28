include ../../cvstools/Makefile.incl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped
HTML2ROFF=../tools/xsl/build/html2roff.xsl
LREFENTRY=../tools/xsl/build/lrefentry.xsl

include Makefile.param

all: param.xsl html-synop.xsl

xml: param.xml

html: param.html

param.html: param.xml
	$(XSLT) $< $(LREFENTRY) $@

param.xml: param.xweb $(PARAMS)
	../../cvstools/paramchk -m Makefile.param $<
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

param.xsl: param.xweb $(PARAMS)
	../../cvstools/paramchk -m Makefile.param $<
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

Makefile.param:
	../../cvstools/paramchk -m $@ param.xweb
	make

html-synop.xsl: ../html/synop.xsl
	$(XSLT) $< $(HTML2ROFF) $@

clean:
	$(RM) param.xml param.html param.xsl
	$(RM) html-synop.xsl
	$(RM) Makefile.param
	echo "# foo" > Makefile.param
