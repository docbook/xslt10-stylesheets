XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

include Makefile.param

all: param.xsl profile-docbook.xsl

xml: param.xml

html: param.html

param.html: param.xml
	$(XSLT) $< ../docsrc/lrefentry.xsl $@

param.xml: param.xweb $(PARAMS)
	../../cvstools/paramchk -m Makefile.param $<
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/w2docbook.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

param.xsl: param.xweb $(PARAMS)
	../../cvstools/paramchk -m Makefile.param $<
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

Makefile.param:
	../../cvstools/paramchk -m $@ param.xweb
	make

profile-docbook.xsl: docbook.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) param.xml param.html param.xsl \
              profile-docbook.xsl profile-chunk.xsl profile-onechunk.xsl \
	$(RM) Makefile.param
	echo "# foo" > Makefile.param
