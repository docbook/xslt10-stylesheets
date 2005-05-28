include ../cvstools/Makefile.incl

CVS2LOG=../cvstools/cvs2log
NEXTVER=
DIFFVER=
ZIPVER=
CVSCHECK := $(shell cvs -n update 2>&1 | grep -v ^cvs | cut -c3-)
RELVER := $(shell grep "<fm:Version" VERSION | sed "s/ *<\/\?fm:Version>//g")
TAGVER := $(shell echo "V$(RELVER)" | sed "s/\.//g")
SFRELID=
FMGO=-N

DIRS=lib common html fo manpages extensions htmlhelp javahelp

.PHONY : distrib clean doc xhtml

all:	xhtml RELEASE-NOTES.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

RELEASE-NOTES.html: RELEASE-NOTES.xml
	$(XJPARSE) $<
	$(XSLT) $< docsrc/doc-link-docbook.xsl $@

RELEASE-NOTES.pdf: RELEASE-NOTES.xml
	$(XSLT) $< fo/docbook.xsl RELEASE-NOTES.fo
	xep RELEASE-NOTES.fo
	rm -f RELEASE-NOTES.fo

xhtml:
	$(MAKE) -C xhtml

doc:
	$(MAKE) -C docsrc
	$(MAKE) -C doc

distrib: all doc
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
endif

newversion:
ifeq ($(CVSCHECK),)
ifeq ($(DIFFVER),)
	@echo "DIFFVER must be specified."
else
ifeq ($(NEXTVER),$(RELVER))
	cvs tag $(TAGVER)
	$(MAKE) DIFFVER=$(DIFFVER) distrib
else
	@echo "VERSION $(RELVER) doesn't match specified version $(NEXTVER)."
endif
endif
else
	@echo "CVS is not up-to-date! ($(CVSCHECK))"
endif

freshmeat:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
else
	$(XSLT) VERSION VERSION /tmp/fm-docbook-xsl sf-relid=$(SFRELID)
	grep -v "<?xml" /tmp/fm-docbook-xsl | freshmeat-submit $(FMGO)
endif

zip:
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
else
	rm -rf /tmp/docbook-xsl-$(ZIPVER)
	rm -f /tmp/tar.exclude
	rm -f /tmp/docbook-xsl-$(ZIPVER).tar.gz
	rm -f /tmp/docbook-xsl-$(ZIPVER).zip
	mkdir /tmp/docbook-xsl-$(ZIPVER)
	touch /tmp/tar.exclude
	find . -print  | grep /CVS$$ | cut -c3- >> /tmp/tar.exclude
	find . -print  | grep /CVS/ | cut -c3- >> /tmp/tar.exclude
	find . -print  | grep /debian/ | cut -c3- >> /tmp/tar.exclude
	find . -print  | grep .classes | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "*~"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".*~"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".*.pyc"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "#*"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".#*"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "Makefile*"   | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "README.CVS"   | cut -c3- >> /tmp/tar.exclude
	tar cf - * --exclude-from /tmp/tar.exclude | (cd /tmp/docbook-xsl-$(ZIPVER); tar xf -)
	cd /tmp && tar cf - docbook-xsl-$(ZIPVER) | gzip > docbook-xsl-$(ZIPVER).tar.gz
	cd /tmp && zip -rpD docbook-xsl-$(ZIPVER).zip docbook-xsl-$(ZIPVER)
	rm -f tar.exclude
endif

clean:
	$(MAKE) -C doc clean
	$(MAKE) -C docsrc clean
