include ../cvstools/Makefile.incl

CVS2LOG=../cvstools/cvs2log
MERGELOGS=../cvstools/mergechangelogs
NEXTVERSION=../cvstools/nextversion
NEXTVER=
DIFFVER=
ZIPVER=

DIRS=common html fo extensions htmlhelp javahelp

.PHONY : distrib clean doc xhtml

all:	xhtml RELEASE-NOTES.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

RELEASE-NOTES.html: RELEASE-NOTES.xml
	$(XSLT) $< html/docbook.xsl $@

xhtml:
	$(MAKE) -C xhtml clean
	rm -f xhtml/.cvsignore
	$(MAKE) -C xhtml .cvsignore
	rm -f xhtml/xslfiles.gen
	touch xhtml/xslfiles.gen
	$(MAKE) -C xhtml xslfiles.list
	$(MAKE) -C xhtml xslfiles

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
	rm -rf /tmp/docbook-xsl-$(ZIPVER)
	rm -f /tmp/tar.exclude
	rm -f /tmp/docbook-xsl-$(ZIPVER).tar.gz
	rm -f /tmp/docbook-xsl-$(ZIPVER).zip
	mkdir /tmp/docbook-xsl-$(ZIPVER)
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
	tar cf - * --exclude-from /tmp/tar.exclude | (cd /tmp/docbook-xsl-$(ZIPVER); tar xf -)
	cd /tmp && tar cf - docbook-xsl-$(ZIPVER) | gzip > docbook-xsl-$(ZIPVER).tar.gz
	cd /tmp && zip -rpD docbook-xsl-$(ZIPVER).zip docbook-xsl-$(ZIPVER)
	rm -f tar.exclude
endif

clean:
	$(MAKE) -C doc clean
	$(MAKE) -C docsrc clean
