include ../cvstools/Makefile.incl
ZIPVER=
DIFFVER=
NEXTVER=

all:
	$(MAKE) -C schema
	$(MAKE) -C xsl

check:
	$(XJPARSE) tests/test.xml
	$(XJPARSE) tests/testcust.xml
	$(XJPARSE) tests/testfull.xml

test: check
	$(SAXON) test.xml xsl/slides.xsl

#doc:
#	perl /projects/src/dtdparse/dtdparse.pl \
#		--title "Slides" --output slides.xml \
#		--decl /usr/lib/sgml/declaration/xml.dcl \
#		--nounexpanded slides.dtd
#	dtdformat --html slides.xml

distrib: check
	$(MAKE) -C doc all
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
endif

newversion:
ifeq ($NEXTVER),)
	$(NEXTVERSION)
else
	$(NEXTVERSION) -v $(NEXTVER)
endif
	make distrib

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
	find demo -print | grep /CVS$$ | cut -c3- >> /tmp/tar.exclude
	find demo -print | grep /CVS/ | cut -c3- >> /tmp/tar.exclude
	find demo -print | grep .classes | cut -c3- >> /tmp/tar.exclude
	find demo -print | grep .cvskeep | cut -c3- >> /tmp/tar.exclude
	find demo -print | grep "~$$" | cut -c3- >> /tmp/tar.exclude
	find demo -type f -name "#*"  | cut -c3- >> /tmp/tar.exclude
	find demo -type f -name ".cvsignore"  | cut -c3- >> /tmp/tar.exclude
	find demo -type f -name "Makefile*"   | cut -c3- >> /tmp/tar.exclude
	find demo -type f -name "README.CVS"   | cut -c3- >> /tmp/tar.exclude
	tar cf - demo --exclude-from /tmp/tar.exclude | (cd /tmp/slides-demo-$(ZIPVER); tar xf -)
	cd /tmp && zip -rpD slides-demo-$(ZIPVER).zip slides-demo-$(ZIPVER)
	rm -f tar.exclude
endif
