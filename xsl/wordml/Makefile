include ../../cvstools/Makefile.incl

# Change this to where you are storing your roundtripping stylesheets
STYLESHEETDIR = .

PARAMPROF=.param.profiled
PARAMSTRIP=.param.stripped

WORDML = $(STYLESHEETDIR)/docbook.xsl
PAGES = $(STYLESHEETDIR)/docbook-pages.xsl
DBKNORM = $(STYLESHEETDIR)/wordml-normalise.xsl
PAGESNORM = $(STYLESHEETDIR)/pages-normalise.xsl
DBKSECTS = $(STYLESHEETDIR)/wordml-sections.xsl
DBKFINAL = $(STYLESHEETDIR)/wordml-final.xsl
TEMPLATE = $(STYLESHEETDIR)/template.xml
TEMPLATEPAGES = $(STYLESHEETDIR)/template-pages.xml

PROC = xsltproc

include Makefile.param

all:	param.xsl

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

param.xsl:	param.xweb
	../../cvstools/paramchk -m Makefile.param $<
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=wordml
	$(XSLT) $(PARAMPROF) ../profiling/strip-attributes.xsl $(PARAMSTRIP) attributes=condition
	$(XSLT) $(PARAMSTRIP) ../../litprog/xtangle.xsl $@
	$(RM) $(PARAMPROF) $(PARAMSTRIP)

Makefile.param:
	../../cvstools/paramchk -m $@ param.xweb

clean:
	$(RM) param.xml param.html param.xsl
	$(RM) Makefile.param
	echo "# foo" > Makefile.param

# WordML-to-DocBook
%.docbook.xml: %.sects.xml $(DBKFINAL) Makefile
	$(PROC) -o $@ $(DBKFINAL) $<

%.sects.xml: %.norm.xml $(DBKSECTS) Makefile
	$(PROC) -o $@ $(DBKSECTS) $<

%.norm.xml: %.wordml.xml $(DBKNORM) Makefile
	$(PROC) -o $@ $(DBKNORM) $<

# Pages-to-DocBook
%.pdocbook.xml: %.psects.xml $(DBKFINAL) Makefile
	$(PROC) -o $@ $(DBKFINAL) $<

%.psects.xml: %.pnorm.xml $(DBKSECTS) Makefile
	$(PROC) -o $@ $(DBKSECTS) $<

%.pnorm.xml: %.pages.xml $(PAGESNORM) Makefile
	$(PROC) -o $@ $(PAGESNORM) $<

# DocBook-to-WordML
%.wordml.xml : %.xml $(WORDML) $(TEMPLATE) Makefile
	xsltproc -o $@ --stringparam wordml.template $(TEMPLATE) $(WORDML) $<

# DocBook-to-Pages
%.pages.xml: %.xml $(PAGES) $(TEMPLATEPAGES) Makefile
	xsltproc -o $@ --stringparam pages.template $(TEMPLATEPAGES) $(PAGES) $<
