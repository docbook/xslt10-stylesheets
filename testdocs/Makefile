include ../cvstools/Makefile.incl

XSLHTML=../xsl/html/docbook.xsl
XSLFO=../xsl/fo/docbook.xsl
XSLCHUNK=../xsl/html/chunk.xsl

CHUNK=0
STYLEOPT=

FORMATTER=xep

RESULT=html

ifeq ($(RESULT),html)
   STYLE=$(XSLHTML)
   USETIDY=1
else
   STYLE=$(XSLFO)
   USETIDY=0
endif

all:
	@echo Select a target

mlang.xml : mlang.pl
	perl mlang.pl > $@

no-toc.$(RESULT): toc.xml
	$(XSLT) $< $(STYLE) $@ generate.book.toc=0 process.source.toc=0 process.empty.source.toc=0 $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif

auto-toc.$(RESULT): toc.xml
	$(XSLT) $< $(STYLE) $@ generate.book.toc=1 process.source.toc=0 process.empty.source.toc=0 $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif

source-toc.$(RESULT): toc.xml
	$(XSLT) $< $(STYLE) $@ generate.book.toc=0 process.source.toc=1 process.empty.source.toc=1 $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif

all-toc-dl.$(RESULT): toc.xml
	$(XSLT) $< $(STYLE) $@ generate.book.toc=1 process.source.toc=1 process.empty.source.toc=1 toc.list.type=dl $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif

all-toc-ul.$(RESULT): toc.xml
	$(XSLT) $< $(STYLE) $@ generate.book.toc=1 process.source.toc=1 process.empty.source.toc=1 toc.list.type=ul $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif

test-toc: all-toc-dl.$(RESULT) all-toc-ul.$(RESULT) auto-toc.$(RESULT) no-toc.$(RESULT) source-toc.$(RESULT)

%.html : %.xml
	$(XJPARSE) $<
ifeq ($(CHUNK),1)
	$(XSLT) $< $(XSLCHUNK) $@ $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn *.html
endif
else
	$(XSLT)  $< $(XSLHTML) $@ $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif
endif

%.fo : %.xml
ifeq ($(FORMATTER),tex)
	$(XSLT) $< $(XSLFO) $@ passivetex.extensions=1 $(STYLEOPT)
else
ifeq ($(FORMATTER),fop)
	$(XSLT) $< $(XSLFO) $@ fop.extensions=1 $(STYLEOPT)
else
	$(XSLT) $< $(XSLFO) $@ $(STYLEOPT)
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
	rm -f *.html *.htm *.fo *.pdf *.ps *.rtf
	rm -f *.log *.aux *.out *.tex *.dvi
	rm -f mlang.xml mlang.sgm
	rm -f toc.hhc htmlhelp.hhp htmlhelp.chm Index.hhk
	rm -f HTML.index
	rm -f jhelpidx.xml jhelpmap.jhm jhelpset.hs jhelptoc.xml
