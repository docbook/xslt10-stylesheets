include ../../cvstools/Makefile.incl

XSLT=$(CVSTOOLSROOT)/xslt --processor=xsltproc

XSLHTML=../xsl/html/docbook.xsl
XSLFO=i18n-fo.xsl
XSLCHUNK=../xsl/html/chunk.xsl

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

all: i18n.pdf i18n.html index.html

index.html:
	$(XJPARSE) $<
	$(XSLT) $< $(XSLCHUNK) $@ $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn *.html
endif

%.html : %.xml
	$(XJPARSE) $<
	$(XSLT)  $< $(XSLHTML) $@ $(STYLEOPT)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif

%.fo : %.xml $(XSLFO) titlepage-fo.xsl
ifeq ($(FORMATTER),tex)
	$(XSLT) $< $(XSLFO) $@ passivetex.extensions=1 $(STYLEOPT)
else
ifeq ($(FORMATTER),fop)
	$(XSLT) $< $(XSLFO) $@ fop.extensions=1 $(STYLEOPT)
else
ifeq ($(FORMATTER),xep)
	$(XSLT) $< $(XSLFO) $@ xep.extensions=1 $(STYLEOPT)
else
	$(XSLT) $< $(XSLFO) $@ $(STYLEOPT)
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

titlepage-fo.xsl: titlepage-fo.xml
	$(XSLT) $< ../../xsl/template/titlepage.xsl $@

clean:
	rm -f *.html *.htm *.fo *.pdf *.ps *.rtf
	rm -f *.log *.aux *.out *.tex *.dvi
	rm -f mlang.xml mlang.sgm
	rm -f toc.hhc htmlhelp.hhp htmlhelp.chm Index.hhk
	rm -f HTML.index
	rm -f jhelpidx.xml jhelpmap.jhm jhelpset.hs jhelptoc.xml
