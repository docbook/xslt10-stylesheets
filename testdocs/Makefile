# -*- Makefile -*-
include ../cvstools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=testdocs

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS =

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES =

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES =

# to make sure that executable bit is retained after packaging,
# you need to explicitly list any executable files here
DISTRIB_EXECUTABLES =


VPATH=.:tests/

.SUFFIXES: .html .fo .xml .pdf .index .tex .rtf .dvi

# testing mode, either dsssl or xsl
MODE		?= xsl

XEP = xep
XEP_OPTS ?= -quiet

DBLATEX = dblatex
DBLATEX_OPTS ?= 

FOP = fop
FOP_OPTS ?=

# stylesheets to use
XSLHTML		?= ../xsl/html/docbook.xsl
XSLFO		?= ../xsl/fo/docbook.xsl
XSLCHUNK	?= ../xsl/html/chunk.xsl
DSSSLHTML	?= ../dsssl/html/docbook.dsl
DSSSLPRINT	?= ../dsssl/print/docbook.dsl

# whether to do chunking
CHUNK		?= 0
# whether to run tidy on resulting HTML output
USETIDY		?= 0
# whether to run validation before running the test
VALIDATE	?= 0

# how to make DSSSL indexes
DSSSLINDEXER	?= perl $(DSSSLROOT)/bin/collateindex.pl

# additional HTML and XSL-FO stylsheet parameters, if any
XSL_HTML_PARAMS	?= glossary.collection="glossary.002.data.xml"
XSL_FO_PARAMS	?= glossary.collection="glossary.002.data.xml"

# additional Jade/DSSSL parameters, if any
DSSSLPARAM	?= -V%generate-article-toc%

# should we make HTML output?
MAKE_HTML ?= yes

# which formatters to use to create PDFs
MAKE_XEP ?= yes
MAKE_DBLATEX ?= yes
MAKE_FOP ?= no
MAKE_PASSIVETEX ?= no

TESTS		:= $(basename $(wildcard tests/*.xml))
TESTBASE	:= $(shell ls -1 tests/*.xml | sed -e 's/\.[0-9][0-9][0-9]\.xml$$//' | sort | uniq)

# ======================================================================

# default rule
.PHONY: all
all:
	@echo "no default rule; try 'make xref.001.html' or 'make alltests'"

.PHONY: $(TESTS)
$(TESTS):

ifeq ($(MAKE_HTML),yes)
	$(MAKE) $(notdir $@).html
endif

ifeq ($(MODE),xsl)
ifeq ($(MAKE_XEP),yes)
	$(MAKE) $(notdir $@).xep.pdf
endif
ifeq ($(MAKE_DBLATEX),yes)
	$(MAKE) $(notdir $@).dbx.pdf
endif
ifeq ($(MAKE_FOP),yes)
	$(MAKE) $(notdir $@).fop.pdf
endif
ifeq ($(MAKE_PASSIVETEX),yes)
	$(MAKE) $(notdir $@).ptx.pdf
endif
else
	$(MAKE) $(notdir $@).dvi
endif

# run all tests in a given category
.PHONY: $(TESTBASE)
$(TESTBASE):
	$(MAKE) $(basename $(notdir $(wildcard $@.[0-9][0-9][0-9].xml)))

# run all tests
.PHONY: alltests tests/images images
alltests: tests/images images $(TESTS)

tests/images:
	if [ ! -h tests/images ]; then \
	  ln -s ../../xsl/images tests/images; \
	fi

images:
	if [ ! -h images ]; then \
	  ln -s ../xsl/images images; \
	fi

# ======================================================================

.xml.html:
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
ifeq ($(MODE),xsl)
ifeq ($(CHUNK),1)
	$(XSLT) $< $(XSLCHUNK) $@ $(XSL_HTML_PARAMS)
else
	$(XSLT)  $< $(XSLHTML) $@ $(XSL_HTML_PARAMS)
endif				# chunk
else				# mode is DSSSL
ifeq ($(CHUNK),1)
	$(JADE) sgml $(DSSSLHTML) $< -V%html-ext%=.html $(DSSSLPARAM)
else
	$(JADE) sgml $(DSSSLHTML) $< -V%html-ext%=.html -Vnochunks $(DSSSLPARAM)> $@
endif
endif
ifeq ($(USETIDY),1)
ifeq ($(CHUNK),1)
	$(TIDY) -iq -n -ascii -mn *.html
else
	$(TIDY) -iq -n -ascii -mn $@
endif
endif

.xml.index:
ifeq ($(MODE),xsl)
	@echo "don't know how to create XSL indexes" >&2
	exit 1
else
	@test -f $*.index.xml || ( echo $(DSSSLINDEXER) -N -o $*.index.xml ; $(DSSSLINDEXER) -N -o $*.index.xml )
	$(JADE) sgml $(DSSSLHTML) $< -Vhtml-index -Vhtml-index-filename=$*.index.xml $(DSSSLPARAM)
	@test ! -f HTML.index || test HTML.index -ot $@ || ( echo mv HTML.index $@ ; mv HTML.index $@ )
endif

%.index.xml:	%.index
ifeq ($(MODE),xsl)
	@echo "don't know how to create XSL indexes" >&2
	exit 1
else
	$(DSSSLINDEXER) -o $@ $<
endif

%.xep.fo: %.xml
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
	$(XSLT) $< $(XSLFO) $@ xep.extensions=1 $(XSL_FO_PARAMS)

%.fop.fo: %.xml
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
	$(XSLT) $< $(XSLFO) $@.fo fop.extensions=1 $(XSL_FO_PARAMS)

%.ptx.fo: %.xml
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
	$(XSLT) $< $(XSLFO) $@ passivetex.extensions=1 $(XSL_FO_PARAMS)

%.jade.fo: %.xml
	$(JADE) fo $(DSSSLPRINT) $< -o $@ $(DSSSLPARAM)

.xml.rtf:
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
ifeq ($(MODE),xsl)
	@echo "not sure how to make RTF"
	exit 1
else
	$(JADE) rtf $(DSSSLPRINT) $< -o $@ $(DSSSLPARAM)
endif

ifeq ($(MODE),dsssl)
.xml.tex:
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
	$(JADE) tex $(DSSSLPRINT) $< -o $@ $(DSSSLPARAM)
endif

ifeq ($(MODE),dsssl)
.tex.dvi:
	jadetex $<

.tex.pdf:
	pdfjadetex $<
endif

%.xep.pdf: %.xep.fo
	$(XEP) $(XEP_OPTS) $< $@

%.dbx.pdf: %.xml
	-$(DBLATEX) $(DBLATEX_OPTS) -o $@ $<

%.fop.pdf: %.fop.fo
	$(FOP) $(FOP_OPTS) $< $@

%.ptx.pdf: %.ptx.fo
	pdftex "&pdfxmltex" $<
	@if [ `grep Rerun $(basename $@).log | wc -l` -gt 0 ]; then \
		pdftex "&pdfxmltex" $< ; \
	fi
	@if [ `grep Rerun $(basename $@).log | wc -l` -gt 0 ]; then \
		pdftex "&pdfxmltex" $< ; \
	fi

# ======================================================================

.PHONY: clean
clean:
	rm -f *.html *.htm *.fo *.pdf *.ps *.rtf
	rm -f *.log *.aux *.out *.tex *.dvi *.index *.index.xml
	rm -f toc.hhc htmlhelp.hhp htmlhelp.chm Index.hhk
	rm -f HTML.index
	rm -f jhelpidx.xml jhelpmap.jhm jhelpset.hs jhelptoc.xml
	find . -name '*~' -o -name '*.bak' -o -name '.#*' -o -name core | xargs rm -f

# remove target if error in the rule
.DELETE_ON_ERROR:

include ../releasetools/Targets.mk
# EOF
