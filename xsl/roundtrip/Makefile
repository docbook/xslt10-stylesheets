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
DBKBLOCKS = $(STYLESHEETDIR)/wordml-blocks.xsl
DBKFINAL = $(STYLESHEETDIR)/wordml-final.xsl
TEMPLATE = $(STYLESHEETDIR)/template.xml
TEMPLATEPAGES = $(STYLESHEETDIR)/template-pages.xml

PROC = xsltproc

include Makefile.param

all: param.xsl

param.xsl:	param.xweb
	../../cvstools/paramchk -m Makefile.param $<
	$(XSLT) $< ../profiling/profile.xsl $(PARAMPROF) profile.condition=wordml
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
	$(MAKE)

clean:
	$(RM) param.xsl
	$(RM) Makefile.param
	echo "# foo" > Makefile.param

# WordML-to-DocBook
%.docbook.xml: %.blocks.xml $(DBKFINAL) Makefile
	$(PROC) -o $@ $(DBKFINAL) $<

%.blocks.xml: %.sects.xml $(DBKBLOCKS) Makefile
	$(PROC) -o $@ $(DBKBLOCKS) $<

%.sects.xml: %.norm.xml $(DBKSECTS) Makefile
	$(PROC) -o $@ $(DBKSECTS) $<

%.norm.xml: %.wordml.xml $(DBKNORM) Makefile
	$(PROC) -o $@ $(DBKNORM) $<

# Pages-to-DocBook
%.pdocbook.xml: %.pblocks.xml $(DBKFINAL) Makefile
	$(PROC) -o $@ $(DBKFINAL) $<

%.pblocks.xml: %.psects.xml $(DBKBLOCKS) Makefile
	$(PROC) -o $@ $(DBKBLOCKS) $<

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
