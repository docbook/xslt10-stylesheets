include ../../cvstools/Makefile.incl

all: ldocbook.xsl

xml:
	echo Nothing to do here, build xml in ../html instead

html:
	echo Nothing to do here, build html in ../html instead

ldocbook.xsl: ../html/ldocbook.xweb ../xtangle.xsl
	$(XSLT) $< ../xtangle.xsl $@ top=fo-top

realclean: clean
	rm -f ldocbook.xsl

clean:
	rm -f ldocbook.{html,xml}
