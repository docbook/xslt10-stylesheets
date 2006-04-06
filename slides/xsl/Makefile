include ../../cvstools/Makefile.incl

.PHONY: fo xhtml

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

DIRS = fo xhtml

all: base param.xsl

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

xml: param.xml

html: param.html

param.html: param.xml
	$(XSLT) $< ../../xsl/docsrc/lrefentry.xsl $@

param.xml: param.xweb
	$(XSLT) $< ../../xsl/profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../../xsl/profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/w2docbook.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

param.xsl: param.xweb
	$(XSLT) $< ../../xsl/profiling/profile.xsl $(PARAMPROF) profile.condition=html
	$(XSLT) $(PARAMPROF) ../../xsl/profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

clean: 
	$(RM) param.xsl param.xml param.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done

