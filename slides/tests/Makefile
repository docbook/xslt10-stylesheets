include ../../cvstools/Makefile.incl
NOFRAMESTYLE=../xsl/slides.xsl
FRAMESTYLE=../xsl/frames.xsl
FOSTYLE=../xsl/fo-plain.xsl
VARS=
FORMATTER=xep
BROWSER=
MULTIFRAME=0
FRAMES=0
OVERLAY=1
TIDY=1

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

all:
	@echo Select a target

test: test.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $(PARAMS)
	make tidy

dbgentext: dbgentext.xml
	$(XJPARSE) $<
	$(XSLT) $< $(HTMLSTYLE) $(PARAMS)
	make tidy

tidy:
ifeq ($(TIDY),1)
	for i in *.html; do \
		if [ "$$i" != "ns4toc.html" ] ; then \
			tidy -iq -latin1 -mn $$i; \
		fi \
	done
endif

%.fo : %.xml
	make -C ../xsl
ifeq ($(FORMATTER),tex)
	saxon $< $(FOSTYLE) $@ passivetex.extensions=1 $(VARS)
else
ifeq ($(FORMATTER),fop)
	saxon $< $(FOSTYLE) $@ fop.extensions=1 $(VARS)
else
	saxon $< $(FOSTYLE) $@ $(VARS)
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

