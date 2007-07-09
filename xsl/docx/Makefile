include ../../releasetools/Variables.mk

XJPARSEFLAGS= -E 0 -w
FO_BUILDER=saxon
XSLTOPT=
PROCOPT=

XEP=xep
XEPFLAGS=

TXT_MAKER = LANG=C w3mmee
TXT_MAKER_FLAGS = -dump -config $(W3MMEECONFIG)
W3MMEECONFIG = ../../releasetools/w3mmee_config

GZIP=gzip
GZIPFLAGS=

.PHONY : clean

VPATH=../docsrc

DIRS=common refentry lib html fo manpages roundtrip slides-html slides-fo website template utility

%.included: %
	$(XINCLUDE) $< >$@

# build reference.pdf.gz except for snapshot releases
ifneq (snapshot,$(findstring snapshot,$(RELVER)))
all: reference.txt.gz reference.pdf.gz html
else
all: reference.txt.gz html
endif

html: base copyright.html warranty.html reference.html index.html

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

copyright.html: copyright.xml $(RSTYLE)
	$(XJPARSE) $(XJPARSEFLAGS) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

warranty.html: warranty.xml $(RSTYLE)
	$(XJPARSE) $(XJPARSEFLAGS) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

reference.html: reference.xml $(RSTYLE)
	$(XJPARSE) $(XJPARSEFLAGS) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

index.html: reference.html
	cp -p $< $@

reference.fo: ../docsrc/reference.dbk.included $(REFERENCEFOXSL)
	$(DOCBOOK_SVN)/buildtools/xslt -$(FO_BUILDER) $< $(REFERENCEFOXSL) > $@

reference.pdf: reference.fo
	$(XEP) $(XEPFLAGS) $<

reference.txt.html: ../docsrc/reference.dbk.included $(REFERENCETXTXSL)
	$(XSLT) $< $(REFERENCETXTXSL) > $@

reference.txt: reference.txt.html
	$(TXT_MAKER) $(TXT_MAKER_FLAGS) $< > $@

reference.pdf.gz: reference.pdf
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

reference.txt.gz: reference.txt
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done
	$(RM) copyright.html
	$(RM) index.html
	$(RM) reference.html
	$(RM) warranty.html
	$(RM) reference.fo
	$(RM) reference.pdf
	$(RM) reference.txt
	$(RM) reference.txt.html
	$(RM) reference.pdf.gz
	$(RM) reference.txt.gz
	$(RM) ../docsrc/reference.dbk.included
