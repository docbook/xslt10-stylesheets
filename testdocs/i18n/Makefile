# -*- Makefile -*-
include ../../cvstools/Makefile.incl

.SUFFIXES: .html .fo .xml .pdf

XSLHTML=../../xsl/html/docbook.xsl
XSLFO=i18n-fo.xsl
XSLCHUNK=../../xsl/html/chunk.xsl

CHUNK=0
USETIDY=1
XSLPARAM=

FORMATTER=xep

XMLFILES=book.xml af.xml ca.xml cs.xml da.xml de.xml el.xml en.xml es.xml \
         et.xml eu.xml fi.xml fr.xml hu.xml id.xml it.xml ja.xml ko.xml nl.xml \
         nn.xml no.xml pl.xml pt.xml pt_br.xml ro.xml ru.xml sk.xml sl.xml \
         sr.xml sv.xml test.xml th.xml tr.xml uk.xml xh.xml zh_cn.xml zh_tw.xml

all: book.html book.pdf

book.html: $(XMLFILES)

book.pdf: $(XMLFILES) titlepage-fo.xsl $(XSLFO)

titlepage-fo.xsl: titlepage-fo.xml
	$(XSLT) $< ../../xsl/template/titlepage.xsl $@

clean:
	rm -f *.html *.htm *.fo *.pdf *.ps *.rtf
	rm -f *.log *.aux *.out *.tex *.dvi

######################################################################

.xml.html:
	$(XJPARSE) $<
ifeq ($(CHUNK),1)
	$(XSLT) $< $(XSLCHUNK) $@ $(XSLPARAM)
ifeq ($(USETIDY),1)
	-$(TIDY) -iq -latin1 -mn *.html
endif
else
	$(XSLT)  $< $(XSLHTML) $@ $(XSLPARAM)
ifeq ($(USETIDY),1)
	-$(TIDY) -iq -latin1 -mn $@
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

#EOF
