include ../../cvstools/Makefile.incl

MODULES=sdbcent.mod sdbhier.mod sdbpool.mod sinclist.mod

all: sdocbook.dtd sdocbookref.dtd

test:
	$(XJPARSE) testcust.xml
	$(XJPARSE) testrefcust.xml
	$(XJPARSE) test.xml
	$(XJPARSE) testcss.xml

sdocbook.dtd: sdocbook-custom.dtd $(MODULES)
	$(XJPARSE) tests/testcust.xml
	$(FLATTEN) sdocbook-custom.dtd > sdocbook.dtd

sdocbookref.dtd: sdocbookref-custom.dtd $(MODULES)
	$(XJPARSE) tests/testrefcust.xml
	$(FLATTEN) sdocbookref-custom.dtd > sdocbookref.dtd

doc: sdocbook.dtd
	dtdparse --title "Simplified DocBook DTD" \
                 --output sdocbook.xml \
                 --decl /usr/lib/sgml/declaration/xml.dcl \
                 --public "-//OASIS//DTD Simplified DocBook XML V4.1.2.5//EN" \
                 --system "http://www.oasis-open.org/docbook/xml/simple/4.1.2.5/sdocbook.dtd" \
                 --nounexpanded sdocbook.dtd
	dtdformat --html --noentities --nonotations sdocbook.xml

refdoc: sdocbookref.dtd
	dtdparse --title "Simplified DocBook RefEntry DTD" --output sdocbookref.xml --decl /usr/lib/sgml/declaration/xml.dcl --public "-//OASIS//DTD Simplified DocBook RefEntry XML V4.1.2.5//EN" --system "http://www.oasis-open.org/docbook/xml/simple/4.1.2.5/sdocbookref.dtd" --nounexpanded sdocbookref.dtd
	dtdformat --html --noentities --nonotations sdocbookref.xml

clean:
	rm -rf sdocbook sdocbookref
	rm -f sdocbook.xml sdocbookref.xml
