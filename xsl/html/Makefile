include ../../cvstools/Makefile.incl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

include Makefile.param

all: titlepage.templates.xsl param.xsl \
     profile-docbook.xsl profile-chunk-code.xsl

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

titlepage.templates.xsl: titlepage.templates.xml ../template/titlepage.xsl
	$(XSLT) $< ../template/titlepage.xsl $@

Makefile.param:
	../../cvstools/paramchk -m $@ param.xweb
	$(MAKE)

profile-docbook.xsl: docbook.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

profile-chunk-code.xsl: chunk-code.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean:
	$(RM) param.xsl \
	profile-docbook.xsl profile-chunk-code.xsl \
	titlepage.templates.xsl
	$(RM) Makefile.param
	echo "# foo" > Makefile.param
