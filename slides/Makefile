include ../cvstools/Makefile.incl
ZIPVER=
MERGEVER=
NEWVER=

all: slides.dtd

slides.dtd: slides-custom.dtd
	$(FLATTEN) $< > $@

check:
	$(XJPARSE) tests/test.xml
	$(XJPARSE) tests/testcust.xml

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
ifeq ($(MERGEVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(MERGEVER) > WhatsNew
endif

newversion:
ifeq ($NEWVER),)
	$(NEXTVERSION)
else
	$(NEXTVERSION) -v $(NEWVER)
endif
	make distrib

zip: distrib
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
else
	make -C tests clean
	rm -rf /tmp/slides-$(ZIPVER)
	rm -f /tmp/tar.exclude
	rm -f /tmp/slides-$(ZIPVER).tar.gz
	rm -f /tmp/slides-$(ZIPVER).zip
	mkdir /tmp/slides-$(ZIPVER)
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
	tar cf - * --exclude-from /tmp/tar.exclude | (cd /tmp/slides-$(ZIPVER); tar xf -)
	cd /tmp && tar cf - slides-$(ZIPVER) | gzip > slides-$(ZIPVER).tar.gz
	cd /tmp && zip -rpD slides-$(ZIPVER).zip slides-$(ZIPVER)
	rm -f tar.exclude
endif
