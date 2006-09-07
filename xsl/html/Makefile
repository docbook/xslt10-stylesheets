include ../../cvstools/Makefile.incl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped
LREFENTRY=../tools/xsl/build/lrefentry.xsl

include Makefile.param

all: titlepage.templates.xsl param.xsl \
     profile-docbook.xsl profile-chunk-code.xsl

xml: param.xml

html: param.html

param.html: param.xml titlepage.templates.xsl
	$(XSLT) $< $(LREFENTRY) $@

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

titlepage.templates.xsl: titlepage.templates.xml ../template/titlepage.xsl
	$(XSLT) $< ../template/titlepage.xsl $@

Makefile.param:
	../../cvstools/paramchk -m $@ param.xweb
	make

profile-docbook.xsl: docbook.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

profile-chunk-code.xsl: chunk-code.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) param.xml param.html param.xsl \
	profile-docbook.xsl profile-chunk-code.xsl \
	titlepage.templates.xsl
	$(RM) Makefile.param
	echo "# foo" > Makefile.param
