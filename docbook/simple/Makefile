include ../../cvstools/Makefile.incl

all: compile

test:
	$(XJPARSE) testcust.xml
	$(XJPARSE) testrefcust.xml
	$(XJPARSE) test.xml
	$(XJPARSE) testcss.xml

compile:
	$(XNSGMLS) -c /share/doctypes/catalog -sv -wundefined testcust.xml
	$(FLATTEN) sdocbook-custom.dtd > sdocbook.dtd
	$(FLATTEN) sdocbookref-custom.dtd > sdocbookref.dtd

#docs:
#	perl /projects/src/dtdparse/dtdparse.pl --title "Simplified DocBook" --output sdocbook.xml --decl /usr/lib/sgml/declaration/xml.dcl --public "-//Norman Walsh//DTD Simplified DocBook XML V$VERS//EN" --system "http://nwalsh.com/docbook/simple/$VERS/sdocbook.dtd" --nounexpanded sdocbook.dtd
#	dtdformat --html --noentities --nonotations sdocbook.xml
#	perl /projects/src/dtdparse/dtdparse.pl --title "Simplified DocBook RefEntry" --output sdocbookref.xml --decl /usr/lib/sgml/declaration/xml.dcl --public "-//Norman Walsh//DTD Simplified DocBook RefEntry XML V$VERS//EN" --system "http://nwalsh.com/docbook/simple/$VERS/sdocbookref.dtd" --nounexpanded sdocbookref.dtd
#	dtdformat --html --noentities --nonotations sdocbookref.xml

clean:
	rm -rf sdocbook sdocbookref
	rm -f sdocbook.xml sdocbookref.xml
