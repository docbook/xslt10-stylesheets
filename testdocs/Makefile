# -*- Makefile -*-
include ../cvstools/Makefile.incl

VPATH=.:tests/

.SUFFIXES: .html .fo .xml .pdf

XSLHTML=../xsl/html/docbook.xsl
XSLFO=../xsl/fo/docbook.xsl
XSLCHUNK=../xsl/html/chunk.xsl

CHUNK=0
USETIDY=1
XSLPARAM=

FORMATTER=xep

# ======================================================================

clean:
	rm -f *.html *.htm *.fo *.pdf *.ps *.rtf
	rm -f *.log *.aux *.out *.tex *.dvi
	rm -f toc.hhc htmlhelp.hhp htmlhelp.chm Index.hhk
	rm -f HTML.index
	rm -f jhelpidx.xml jhelpmap.jhm jhelpset.hs jhelptoc.xml

# ======================================================================

.xml.html:
	$(XJPARSE) $<
ifeq ($(CHUNK),1)
	$(XSLT) $< $(XSLCHUNK) $@ $(XSLPARAM)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn *.html
endif
else
	$(XSLT)  $< $(XSLHTML) $@ $(XSLPARAM)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif
endif

.xml.fo:
ifeq ($(FORMATTER),tex)
	$(XSLT) $< $(XSLFO) $@ passivetex.extensions=1 $(XSLPARAM)
else
ifeq ($(FORMATTER),fop)
	$(XSLT) $< $(XSLFO) $@ fop.extensions=1 $(XSLPARAM)
else
ifeq ($(FORMATTER),xep)
	$(XSLT) $< $(XSLFO) $@ xep.extensions=1 $(XSLPARAM)
else
	$(XSLT) $< $(XSLFO) $@ $(XSLPARAM)
endif
endif
endif

.fo.pdf:
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
	echo No formatter specified. How would you like me to make the PDF file?
endif
endif
endif

# EOF
