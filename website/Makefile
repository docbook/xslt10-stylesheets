include ../cvstools/Makefile.incl
ZIPVER=
DIFFVER=
NEXTVER=

.PHONY : distrib clean

all:
	make -C schema all
	make -C extensions all
	make -C extensions jars

distrib:
	make -C example clean
	make -C example TEXTONLY=1 clean
	make -C example all
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
	make distrib

zip: distrib
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
else
	rm -rf /tmp/website-$(ZIPVER)
	rm -f /tmp/tar.exclude
	rm -f /tmp/website-$(ZIPVER).tar.gz
	rm -f /tmp/website-$(ZIPVER).zip
	mkdir /tmp/website-$(ZIPVER)
	touch /tmp/tar.exclude
	find . -print | grep /CVS$$ | cut -c3- >> /tmp/tar.exclude
	find . -print | grep /CVS/ | cut -c3- >> /tmp/tar.exclude
	find . -print | grep .classes | cut -c3- >> /tmp/tar.exclude
	find . -print | grep .cvskeep | cut -c3- >> /tmp/tar.exclude
	find . -print | grep "~$$" | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "#*"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "Makefile*"   | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "README.CVS"   | cut -c3- >> /tmp/tar.exclude
	tar cf - * --exclude-from /tmp/tar.exclude | (cd /tmp/website-$(ZIPVER); tar xf -)
	cd /tmp && tar cf - website-$(ZIPVER) | gzip > website-$(ZIPVER).tar.gz
	cd /tmp && zip -rpD website-$(ZIPVER).zip website-$(ZIPVER)
	rm -f tar.exclude
endif

clean:
	make -C example clean
	make -C example TEXTONLY=1 clean
