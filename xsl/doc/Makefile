include ../../releasetools/Variables.mk
XSLTOPT=
PROCOPT=

XEP=xep
XEPFLAGS=
REFERENCEFOXSL=../docsrc/reference-fo.xsl

REFERENCETXTXSL=../docsrc/reference-txt.xsl
TXT_MAKER = LANG=C w3mmee
TXT_MAKER_FLAGS = -dump -config $(W3MMEECONFIG)
W3MMEECONFIG = ../../releasetools/w3mmee_config

GZIP=gzip
GZIPFLAGS=

.PHONY : clean

RSTYLE=../docsrc/reference.xsl
VPATH=../docsrc

DIRS=common refentry lib html fo manpages wordml slides website template

all: reference.txt.gz html

html: base copyright.html warranty.html reference.html index.html

base:
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
	cp -p $< $@

reference.fo: ../docsrc/reference.dbk $(REFERENCEFOXSL)
	$(XSLTPROC) --xinclude $(REFERENCEFOXSL) $< > $@

reference.pdf: reference.fo
	$(XEP) $(XEPFLAGS) $<

reference.txt: ../docsrc/reference.dbk $(REFERENCETXTXSL)
	$(XSLTPROC) --xinclude $(REFERENCETXTXSL) $< | $(TXT_MAKER) $(TXT_MAKER_FLAGS) > $@

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
	$(RM) reference.fo
	$(RM) reference.pdf
	$(RM) reference.txt
	$(RM) reference.pdf.gz
	$(RM) reference.txt.gz
