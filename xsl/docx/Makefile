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

HTMLMANIFEST=HTML.manifest

DIRS=common fo html lib manpages pi refentry roundtrip slides/fo slides/html template utility website

.PHONY : clean

%.included: %
	$(XINCLUDE) $< >$@

# build reference.pdf.gz except for snapshot releases
ifneq (snapshot,$(findstring snapshot,$(RELVER)))
all: reference.txt.gz reference.css reference.pdf.gz
else
all: reference.txt.gz reference.css
endif

#reference.html: ../docsrcx/reference.xml.included $(REFERENCETXTXSL)
#	$(XSLT) $< $(REFERENCETXTXSL) > $@

index.html: ../docsrcx/reference.xml.included $(RSTYLE)
	$(XSLT) $< $(RSTYLE) > $@

reference.html: index.html
	cp -p $< $@

reference.css: ../docsrcx/reference.css
	cp -p $< .
	for dir in $(DIRS); do cp -p $< $$dir; done

debug:
	@echo $(DIRS)

reference.fo: ../docsrc/reference.xml.included $(REFERENCEFOXSL)
	$(DOCBOOK_SVN)/buildtools/xslt -$(FO_BUILDER) $< $(REFERENCEFOXSL) > $@

reference.pdf: reference.fo
	$(XEP) $(XEPFLAGS) $<

reference.txt: reference.html
	$(TXT_MAKER) $(TXT_MAKER_FLAGS) $< > $@

reference.pdf.gz: reference.pdf
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

reference.txt.gz: reference.txt
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

clean:
	$(RM) reference.css
	for dir in $(DIRS); do $(RM) $$dir/reference.css; done
	$(RM) reference.html
	$(RM) reference.fo
	$(RM) reference.pdf
	$(RM) reference.pdf.gz
	$(RM) reference.txt.gz
	$(RM) reference.txt
	$(RM) ../docsrc/reference.xml.included
	for file in $$(cat $(HTMLMANIFEST)); do $(RM) $$file; done
	$(RM) $(HTMLMANIFEST)
