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

XMLID_TO_ID=../tools/xsl/build/xmlid-to-id.xsl

GZIP=gzip
GZIPFLAGS=

HTMLMANIFEST=HTML.manifest

DIRS=common fo html lib manpages pi refentry roundtrip slides/fo slides/html template utility website

.PHONY : clean

# rule for building file with includes resolved; uses hacky
# stylesheet to transform all @xml:id instances to @id instances;
# otherwise, xsltproc reports duplicate ID errors...
%.included: %
	$(XINCLUDE) $< > $@.tmp
	$(DOCBOOK_SVN)/buildtools/saxon $@.tmp $(XMLID_TO_ID) > $@
	$(RM) $@.tmp

# build reference.pdf.gz except for snapshot releases
ifneq (snapshot,$(findstring snapshot,$(RELVER)))
all: fo/page.png reference.html reference.css reference.txt.gz reference.pdf.gz
else
all: fo/page.png reference.html reference.css reference.txt.gz
endif

#reference.html: ../docsrcx/reference.xml.included $(REFERENCETXTXSL)
#	$(XSLT) $< $(REFERENCETXTXSL) > $@

index.html: ../docsrcx/reference.xml.included $(RSTYLE)
	$(XSLT) $< $(RSTYLE)

reference.html: index.html
	cp -p $< $@

reference.css: ../docsrcx/reference.css
	cp -p $< .
	for dir in $(DIRS); do cp -p $< $$dir; done

reference.fo: ../docsrcx/reference.xml.included $(REFERENCEFOXSL) fo/page.png
	$(DOCBOOK_SVN)/buildtools/xslt -$(FO_BUILDER) $< $(REFERENCEFOXSL) > $@

reference.pdf: reference.fo
	$(XEP) $(XEPFLAGS) $<

reference.txt.html: ../docsrcx/reference.xml.included $(REFERENCETXTXSL)
	$(XSLT) $< $(REFERENCETXTXSL) > $@

reference.txt: reference.txt.html
	$(TXT_MAKER) $(TXT_MAKER_FLAGS) $< > $@

reference.pdf.gz: reference.pdf
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

reference.txt.gz: reference.txt
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

fo/page.png: ../docsrcx/page.png
	cp -p $< $@

clean:
	$(RM) reference.css
	for dir in $(DIRS); do $(RM) $$dir/reference.css; done
	$(RM) reference.html
	$(RM) reference.txt.html
	$(RM) reference.fo
	$(RM) reference.pdf
	$(RM) reference.pdf.gz
	$(RM) reference.txt.gz
	$(RM) reference.txt
	$(RM) fo/page.png
	$(RM) ../docsrc/reference.xml.included
	if [ -f $(HTMLMANIFEST) ]; then for file in $$(cat $(HTMLMANIFEST)); do $(RM) $$file; done; fi
	$(RM) $(HTMLMANIFEST)
