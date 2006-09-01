include ../../cvstools/Makefile.incl
XSLTOPT=
PROCOPT=

PDF_MAKER=xep
DOCBOOK_FILE_EXTENSION=.dbk
REFERENCE_MAKEFILE=../tools/make/Makefile.DocBook
FO_PARAMS = "--stringparam refentry.pagebreak 0"
HTML_PARAMS = "--stringparam html.longdesc 0 --param local.l10n.xml \"document('../common/l10n.xsl')\" --stringparam reference.autolabel '1' --stringparam toc.max.depth '1'"
TXT_MAKER = "LANG=C w3mmee"
TXT_MAKER_FLAGS = "-dump -config $(W3MMEECONFIG)"
W3MMEECONFIG = "../../releasetools/w3mmee_config"

GZIP=gzip
GZIPFLAGS=

.PHONY : clean

RSTYLE=../docsrc/reference.xsl
VPATH=../docsrc

DIRS=common refentry lib html fo manpages wordml slides website template pi

all: copyright.html warranty.html reference.html index.html reference.txt.gz
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

copyright.html: copyright.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

warranty.html: warranty.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

reference.html: reference.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

index.html: reference.html
	cp -pR $< $@

reference.pdf: ../docsrc/reference.dbk $(REFERENCE_MAKEFILE)
	$(MAKE) -f $(REFERENCE_MAKEFILE) ../docsrc/reference.pdf PDF_MAKER=$(PDF_MAKER) DOCBOOK_FILE_EXTENSION=$(DOCBOOK_FILE_EXTENSION) FO_PARAMS=$(FO_PARAMS) \
	  && mv ../docsrc/reference.pdf .

reference.txt: ../docsrc/reference.dbk $(REFERENCE_MAKEFILE)
	$(MAKE) -f $(REFERENCE_MAKEFILE) ../docsrc/reference.txt TXT_MAKER=$(TXT_MAKER) TXT_MAKER_FLAGS=$(TXT_MAKER_FLAGS) DOCBOOK_FILE_EXTENSION=$(DOCBOOK_FILE_EXTENSION) HTML_PARAMS=$(HTML_PARAMS) \
	  && mv ../docsrc/reference.txt . && $(RM) ../docsrc/reference.html

reference.pdf.gz: reference.pdf
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

reference.txt.gz: reference.txt
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

clean:
	$(RM) *.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done
	$(RM) ../docsrc/reference.fo
	$(RM) ../docsrc/reference.pdf
	$(RM) ../docsrc/reference.txt
	$(RM) reference.pdf
	$(RM) reference.txt
	$(RM) reference.pdf.gz
	$(RM) reference.txt.gz
