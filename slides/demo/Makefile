include ../../cvstools/Makefile.incl

VPATH=./source
FORMATTER=xep
FOSTYLE=../xsl/fo/plain.xsl
FO_OPTS= ulink.show=0 ulink.footnotes=1 draft.mode="no"
DOCSTYLE=http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl

DIRS = browser graphics \
       default plain tables vslides w3c \
       frames1 frames2 frames3 frames4 frames5 frames6 frames7

all: index.html slides.pdf
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

index.html: index.xml
	$(XSLT) $< $(DOCSTYLE) $@

%.fo : %.xml
ifeq ($(FORMATTER),tex)
	$(XSLT) $< $(FOSTYLE) $@ $(FO_OPTS) passivetex.extensions=1
else
ifeq ($(FORMATTER),fop)
	$(XSLT) $< $(FOSTYLE) $@ $(FO_OPTS) fop.extensions=1
else
ifeq ($(FORMATTER),xep)
	$(XSLT) $< $(FOSTYLE) $@ $(FO_OPTS) xep.extensions=1
else
	$(XSLT) $< $(FOSTYLE) $@ $(FO_OPTS)
endif
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
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done
	rm -f index.html
	rm -f slides.pdf
