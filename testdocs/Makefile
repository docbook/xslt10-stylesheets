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
VALIDATE=1

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
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
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
ifeq ($(VALIDATE),1)
	$(XJPARSE) $<
endif
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

distrib:
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
endif

newversion:
ifeq ($(NEXTVER),)
	$(NEXTVERSION)
else
	$(NEXTVERSION) -v $(NEXTVER)
endif
	make DIFFVER=$(DIFFVER) distrib

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

# EOF
