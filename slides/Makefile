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

all:
	$(MAKE) -C schema
	$(MAKE) -C xsl

check:
	$(XJPARSE) tests/test.xml
	$(XJPARSE) tests/testcust.xml
	$(XJPARSE) tests/testfull.xml

distrib: check
	$(MAKE) -C doc all
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
	$(XSLT) VERSION VERSION /tmp/fm-docbook-slides sf-relid=$(SFRELID)
	grep -v "<?xml" /tmp/fm-docbook-slides | freshmeat-submit $(FMGO)
endif

zip:
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
else
	make -C tests clean
	rm -rf /tmp/slides-$(ZIPVER)
	rm -f /tmp/slides-$(ZIPVER).tar.gz
	rm -f /tmp/slides-$(ZIPVER).zip
	mkdir /tmp/slides-$(ZIPVER)
	rm -f /tmp/tar.exclude
	touch /tmp/tar.exclude
	find . -print | grep /CVS$$ | cut -c3- >> /tmp/tar.exclude
	find . -print | grep /CVS/ | cut -c3- >> /tmp/tar.exclude
	find . -print | grep .classes | cut -c3- >> /tmp/tar.exclude
	find . -print | grep .cvskeep | cut -c3- >> /tmp/tar.exclude
	find . -print | grep demo/ | cut -c3- >> /tmp/tar.exclude
	find . -print | grep "~$$" | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "#*"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "Makefile*"   | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "README.CVS"   | cut -c3- >> /tmp/tar.exclude
	tar cf - * --exclude-from /tmp/tar.exclude | (cd /tmp/slides-$(ZIPVER); tar xf -)
	cd /tmp && tar cf - slides-$(ZIPVER) | gzip > slides-$(ZIPVER).tar.gz
	cd /tmp && zip -rpD slides-$(ZIPVER).zip slides-$(ZIPVER)
	rm -rf /tmp/slides-demo-$(ZIPVER)
	rm -f /tmp/slides-demo-$(ZIPVER).zip
	mkdir /tmp/slides-demo-$(ZIPVER)
	rm -f /tmp/tar.exclude
	touch /tmp/tar.exclude
	-find demo -print | grep /CVS$$    >> /tmp/tar.exclude
	-find demo -print | grep /CVS/     >> /tmp/tar.exclude
	-find demo -print | grep .classes  >> /tmp/tar.exclude
	-find demo -print | grep .cvskeep  >> /tmp/tar.exclude
	-find demo -print | grep "~$$"     >> /tmp/tar.exclude
	-find demo -type f -name "#*"      >> /tmp/tar.exclude
	-find demo -type f -name ".cvsignore" >> /tmp/tar.exclude
	-find demo -type f -name "Makefile*"  >> /tmp/tar.exclude
	-find demo -type f -name "README.CVS" >> /tmp/tar.exclude
	tar cf - demo --exclude-from /tmp/tar.exclude | (cd /tmp/slides-demo-$(ZIPVER); tar xf -)
	cd /tmp && zip -rpD slides-demo-$(ZIPVER).zip slides-demo-$(ZIPVER)
	rm -f tar.exclude
endif
