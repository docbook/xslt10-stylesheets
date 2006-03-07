include ../../cvstools/Makefile.incl

MODULES=sdbcent.mod sdbhier.mod sdbpool.mod sinclist.mod
VERSION=
FMGO=-N

all: sdocbook.dtd sdocbookref.dtd

test:
	$(XJPARSE) -d tests/testcust.xml
	$(XJPARSE) -d tests/testrefcust.xml
	$(XJPARSE) -d tests/test.xml
	$(XJPARSE) -d tests/testcss.xml

freshmeat:
ifeq ($(VERSION),)
	@echo "You must specify the version (VERSION)"
else
	$(XSLT) freshmeat.xsl freshmeat.xsl /tmp/fm-docbook-simple version=$(VERSION)
	grep -v "<?xml" /tmp/fm-docbook-simple | freshmeat-submit $(FMGO)
endif

sdocbook.dtd: sdocbook-custom.dtd $(MODULES)
	$(XJPARSE) -d tests/testcust.xml
	$(FLATTEN) sdocbook-custom.dtd > sdocbook.dtd

sdocbookref.dtd: sdocbookref-custom.dtd $(MODULES)
	$(XJPARSE) -d tests/testrefcust.xml
	$(FLATTEN) sdocbookref-custom.dtd > sdocbookref.dtd

doc: sdocbook.dtd
	dtdparse --title "Simplified DocBook DTD" \
                 --output sdocbook.xml \
                 --decl /usr/lib/sgml/declaration/xml.dcl \
                 --public "-//OASIS//DTD Simplified DocBook XML V$(VERSION)//EN" \
                 --system "http://docbook.org/xml/simple/$(VERSION)/sdocbook.dtd" \
                 --nounexpanded sdocbook.dtd
	dtdformat --html --noentities --nonotations sdocbook.xml

refdoc: sdocbookref.dtd
	dtdparse --title "Simplified DocBook RefEntry DTD" --output sdocbookref.xml --decl /usr/lib/sgml/declaration/xml.dcl --public "-//OASIS//DTD Simplified DocBook RefEntry XML V$(VERSION)//EN" --system "http://docbook.org/xml/simple/$(VERSION)/sdocbookref.dtd" --nounexpanded sdocbookref.dtd
	dtdformat --html --noentities --nonotations sdocbookref.xml

clean:
	rm -rf sdocbook sdocbookref
	rm -f sdocbook.xml sdocbookref.xml
