include ../../cvstools/Makefile.incl

all: index.html param.html

index.html: slides.xml
	$(XSLT) $< ../../xsl/html/docbook.xsl $@

param.html:
	$(MAKE) -C ../xsl/html param.html
	cp ../xsl/html/param.html .

clean:
	rm -f *.html

