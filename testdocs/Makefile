# -*- Makefile -*-
include ../cvstools/Makefile.incl

VPATH=.:tests/

.SUFFIXES: .html .fo .xml .pdf .index

# testing mode, either dsssl or xsl
MODE=xsl

# stylesheets to use
XSLHTML=../xsl/html/docbook.xsl
XSLFO=../xsl/fo/docbook.xsl
XSLCHUNK=../xsl/html/chunk.xsl
DSSSLHTML=../dsssl/html/docbook.dsl
DSSSLPRINT=../dsssl/print/docbook.dsl

# whether to do chunking
CHUNK=0
# whether to run tidy on resulting HTML output
USETIDY=0
# whether to run validation before running the test
VALIDATE=0

# how to make DSSSL indexes
DSSSLINDEXER	?= perl $(DSSSLROOT)/bin/collateindex.pl

# additional XSL parameters, if any
XSLPARAM=

# can be xep, fop, or tex
#  fixme: should be in Makefile.incl ?
FO_FORMATTER=xep


# ======================================================================

# default rule, run all tests
.PHONY: test
test:

.xml.html:
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
ifeq ($(MODE),xsl)
ifeq ($(CHUNK),1)
	$(XSLT) $< $(XSLCHUNK) $@ $(XSLPARAM)
else
	$(XSLT)  $< $(XSLHTML) $@ $(XSLPARAM)
endif				# chunk
else				# mode is DSSSL
ifeq ($(CHUNK),1)
	$(JADE) sgml $(DSSSLHTML) $< -V%html-ext%=.html
else
	$(JADE) sgml $(DSSSLHTML) $< -V%html-ext%=.html -Vnochunks > $@
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
	@echo "don't know how to create XSL indexes"
	exit 1
else
	@test -f $*.index.xml || ( echo $(DSSSLINDEXER) -N -o $*.index.xml ; $(DSSSLINDEXER) -N -o $*.index.xml )
	$(JADE) sgml $(DSSSLHTML) $< -Vhtml-index -Vhtml-index-filename=$*.index.xml
	@test ! -f HTML.index || test HTML.index -ot $@ || ( echo mv HTML.index $@ ; mv HTML.index $@ )
endif

%.index.xml:	%.index
	$(DSSSLINDEXER) -o $@ $<


.xml.fo:
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
ifeq ($(MODE),xsl)
	$(XSLT) $< $(XSLFO) $@ $(FO_FORMATTER).extensions=1 $(XSLPARAM)
else
	$(JADE) fo $(DSSSLPRINT) $< -o $@
endif

.fo.pdf:
ifeq ($(FO_FORMATTER),tex)
	pdftex "&pdfxmltex" $<
	@if [ `grep Rerun $(basename $@).log | wc -l` -gt 0 ]; then \
		pdftex "&pdfxmltex" $< ; \
	fi
	@if [ `grep Rerun $(basename $@).log | wc -l` -gt 0 ]; then \
		pdftex "&pdfxmltex" $< ; \
	fi
else
ifeq ($(FO_FORMATTER),fop)
	fop $< $@
else
ifeq ($(FO_FORMATTER),xep)
	xep $<
else
	echo No formatter specified. How would you like me to make the PDF file?
endif
endif
endif

# ======================================================================

.PHONY: clean
clean:
	rm -f *.html *.htm *.fo *.pdf *.ps *.rtf
	rm -f *.log *.aux *.out *.tex *.dvi *.index *.index.xml
	rm -f toc.hhc htmlhelp.hhp htmlhelp.chm Index.hhk
	rm -f HTML.index
	rm -f jhelpidx.xml jhelpmap.jhm jhelpset.hs jhelptoc.xml

.PHONY: distrib
distrib:
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
endif

.PHONY: newversion
newversion:
ifeq ($(NEXTVER),)
	$(NEXTVERSION)
else
	$(NEXTVERSION) -v $(NEXTVER)
endif
	make DIFFVER=$(DIFFVER) distrib

.PHONY: zip
zip:
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
else
	rm -rf /tmp/docbook-testdocs-$(ZIPVER)
	rm -f /tmp/tar.exclude
	rm -f /tmp/docbook-testdocs-$(ZIPVER).tar.gz
	rm -f /tmp/docbook-testdocs-$(ZIPVER).zip
	mkdir /tmp/docbook-testdocs-$(ZIPVER)
	touch /tmp/tar.exclude
	find . -print  | grep /CVS$$ | cut -c3- >> /tmp/tar.exclude
	find . -print  | grep /CVS/ | cut -c3- >> /tmp/tar.exclude
	find . -print  | grep .classes | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "*~"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".*~"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "#*"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "Makefile*"   | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "README.CVS"   | cut -c3- >> /tmp/tar.exclude
	tar cf - * --exclude-from /tmp/tar.exclude | (cd /tmp/docbook-testdocs-$(ZIPVER); tar xf -)
	cd /tmp && tar cf - docbook-testdocs-$(ZIPVER) | gzip > docbook-testdocs-$(ZIPVER).tar.gz
	cd /tmp && zip -rpD docbook-testdocs-$(ZIPVER).zip docbook-testdocs-$(ZIPVER)
	rm -f tar.exclude
endif

# remove target if error in the rule
.DELETE_ON_ERROR:

# EOF
