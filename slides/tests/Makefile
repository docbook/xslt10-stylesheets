include ../../cvstools/Makefile.incl
HTMLSTYLE=../xsl/slides.xsl
FOSTYLE=../xsl/fo-plain.xsl
VARS=
FORMATTER=xep
BROWSER=
MULTIFRAME=0
TIDY=1

all:
	@echo Select a target

test: test.xml
	$(XJPARSE) test.xml
ifeq ($(BROWSER),)
	$(XSLT) $< $(HTMLSTYLE) /dev/null $(VARS) multiframe=$(MULTIFRAME)
else
	$(XSLT) $< $(HTMLSTYLE) /dev/null $(VARS) $(BROWSER)=1 multiframe=$(MULTIFRAME)
endif

testcust:
	$(XJPARSE) test.xml

dbgentext: dbgentext.xml
	$(XJPARSE) $<
ifeq ($(BROWSER),)
	$(XSLT) $< $(HTMLSTYLE) /dev/null $(VARS) multiframe=$(MULTIFRAME)
else
	$(XSLT) $< $(HTMLSTYLE) /dev/null $(VARS) $(BROWSER)=1 multiframe=$(MULTIFRAME)
endif
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

