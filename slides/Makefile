include ../cvsroot/Makefile.incl

all: slides.dtd

slides.dtd: slides-custom.dtd
	$(FLATTEN) $< > $@

check:
	$(XJPARSE) test.xml
	$(XJPARSE) testcust.xml

test: check
	$(SAXON) test.xml xsl/slides.xsl

#doc:
#	perl /projects/src/dtdparse/dtdparse.pl \
#		--title "Slides" --output slides.xml \
#		--decl /usr/lib/sgml/declaration/xml.dcl \
#		--nounexpanded slides.dtd
#	dtdformat --html slides.xml

distrib: check
	$(CVS2LOG) -w
	$(MERGECHANGELOGS) > WhatsNew

newversion:
	nextversion
	make distrib

clean:
	rm -rf slides
	rm -f *.html slides.xml
