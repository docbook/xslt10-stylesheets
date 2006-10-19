include ../../cvstools/Makefile.incl

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

include Makefile.param

all: titlepage.templates.xsl param.xsl profile-docbook.xsl

param.xsl: param.xweb $(PARAMS)
	../../cvstools/paramchk -m Makefile.param $<
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=fo
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

clean:
	$(RM) param.xml \
              profile-docbook.xsl \
              titlepage.templates.xsl
	$(RM) Makefile.param
	echo "# foo" > Makefile.param
