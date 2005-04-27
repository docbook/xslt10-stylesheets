include ../../cvstools/Makefile.incl
STYLE=tables
NOFRAMESTYLE=../xsl/html/$(STYLE).xsl
FRAMESTYLE=../xsl/html/frames.xsl
FOSTYLE=../xsl/fo/plain.xsl
VARS=chunker.output.doctype-system=1 draft.mode="no"
FORMATTER=fop
FORMATTER_OPTS=-q
BROWSER=
MULTIFRAME=0
FRAMES=0
OVERLAY=1
TIDY=0
XML_FILES=dbgentext.xml dbhtml-dir.xml minimal.xml test-full.xml test.xml testcust.xml testfull.xml tr-862918.xml
PDF_FILES  = $(foreach file,$(basename $(XML_FILES)),$(file).pdf)
HTML_FILES = $(foreach file,$(basename $(XML_FILES)),$(file).html)

ifeq ($(FRAMES),0)
  HTMLSTYLE=$(NOFRAMESTYLE)
else
  HTMLSTYLE=$(FRAMESTYLE)
endif

ifeq ($(BROWSER),)
  PARAMS=$(VARS) multiframe=$(MULTIFRAME) overlay=$(OVERLAY)
else
  PARAMS=$(VARS) $(BROWSER)=1 multiframe=$(MULTIFRAME) overlay=$(OVERLAY)
endif

all: $(HTML_FILES) tidy $(PDF_FILES)
#	@echo Select a target

tidy:
ifeq ($(TIDY),1)
	for i in *.html; do \
		if [ "$$i" != "ns4toc.html" ] ; then \
			tidy -iq -latin0 -mn $$i; \
		fi \
	done
endif

%.html: %.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) - $(PARAMS)
	touch $@

%.fo : %.xml
ifeq ($(FORMATTER),tex)
	$(XSLT) $< $(FOSTYLE) $(FORMATTER_OPTS) $@ passivetex.extensions=1 $(VARS)
else
ifeq ($(FORMATTER),fop)
	$(XSLT) $< $(FOSTYLE) -q $(FORMATTER_OPTS) $@ fop.extensions=1 $(VARS)
else
	$(XSLT) $< $(FOSTYLE) $(FORMATTER_OPTS) $@ $(VARS)
endif
endif

%.pdf : %.fo
ifeq ($(FORMATTER),tex)
	pdftex "&pdfxmltex" $<
	@if [ `grep Rerun $(basename $@).log | wc -l` -gt 0 ]; then \
		pdftex "&pdfxmltex" $< ; \
	fi
	@if [ `grep Rerun $(basename $@).log | wc -l` -gt 0 ]; then \
		pdftex "&pdfxmltex" $< ; \
	fi
else
ifeq ($(FORMATTER),fop)
	fop $< $@
else
ifeq ($(FORMATTER),xep)
	xep $<
else
	echo How would you like me to make the PDF file?
endif
endif
endif

clean:
	rm -f *.html *.fo *.pdf *.ps
	rm -f *.log *.aux *.out
	rm -f dbhtml-dir-test/*.html

