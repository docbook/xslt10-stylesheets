# $Id$
include ../cvstools/Makefile.incl
DISTRO=website
RELVER=$(shell cat ./VERSION)
ZIPVER=$(RELVER)
DIFFVER=
NEXTVER=
TMP=/tmp

.PHONY : distrib clean example

all:
	$(MAKE) -C schema all
	$(MAKE) -C extensions all

distrib: example
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
endif

example:
	$(MAKE) -C example DOCBOOK_WEBSITE=..

newversion:
ifeq ($(NEXTVER),)
	$(NEXTVERSION)
else
	$(NEXTVERSION) -v $(NEXTVER)
endif
	$(MAKE) distrib

excludes:
	rm -f $(TMP)/tar.exclude
	touch $(TMP)/tar.exclude

zip: excludes
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
	exit 1
else
	find . -type f | xargs chmod 0644
	find . -type d | xargs chmod 0755
ifneq ($(EXECUTABLES),)
	chmod 0755 $(EXECUTABLES)
endif
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.gz
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip
	umask 022; mkdir $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	find . -print  | grep /CVS$$       | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep /CVS/        | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep /debian/     | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep .classes     | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep "~$$"        | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".*.pyc"      | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "#*"          | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".#*"         | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "prj.el"      | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "Makefile*"   | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "README.CVS"  | cut -c3- >> $(TMP)/tar.exclude
	tar cf - * --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); tar xf -)
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
	rm -f $(TMP)/tar.exclude
endif

clean:
	$(MAKE) -C extensions clean
	$(MAKE) -C example clean
	$(MAKE) -C example TEXTONLY=1 clean

realclean: clean
	$(MAKE) -C extensions realclean
	$(MAKE) -C example realclean
