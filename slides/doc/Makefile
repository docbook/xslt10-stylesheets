include ../../cvstools/Makefile.incl

CP=cp

all: index.html param.html

param.html:
	make -C ../xsl param.html
	$(CP) ../xsl/param.html .

index.html: slides.xml
	$(XSLT) $< ../../xsl/html/docbook.xsl $@

clean:
	rm -f *.html

