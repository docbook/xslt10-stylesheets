include ../../cvstools/Makefile.incl

all: fib.pl doc.xsd fib.xpp doc.xpp

html: doc.html fib.html

xml: doc.xml fib.xml

doc.html: doc.xml
	$(XSLT) $< doc.xsl $@

doc.xml: doc.xweb
	$(XSLT) $< ../weave.xsl $@

doc.xsd: doc.xweb
	$(XSLT) $< ../xtangle.xsl $@

doc.xpp: doc.xweb prettyprint.pl
	perl prettyprint.pl $< > $@

fib.html: fib.xml
	$(XSLT) $< ../html/ldocbook.xsl $@

fib.fo: fib.xml
	$(XSLT) $< ../fo/ldocbook.xsl $@

fib.pdf: fib.fo
	xep $< $@

fib.pl: fib.xweb
	$(XSLT) $< ../tangle.xsl $@

fib.xml: fib.xweb
	$(XSLT) $< ../wdocbook.xsl $@

fib.xpp: fib.xweb prettyprint.pl
	perl prettyprint.pl $< > $@

defns.html: defns.xml
	$(XSLT) $< doc.xsl $@

defns.xml: defns.xweb
	$(XSLT) $< ../weave.xsl $@

defns.rng: defns.xweb
	$(XSLT) $< ../xtangle.xsl $@

realclean: clean
	rm -f defns.rng
	rm -f doc.{xsd,xpp}
	rm -f fib.{pl,xpp}

clean:
	rm -f defns.{html,xml,fo,pdf}
	rm -f doc.{html,xml,fo,pdf}
	rm -f fib.{html,xml,fo,pdf}
