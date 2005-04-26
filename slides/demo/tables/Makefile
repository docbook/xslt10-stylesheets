include ../../../cvstools/Makefile.incl
SLIDES=../source/slides.xml

index.html: ../../xsl/html/tables.xsl

	$(XSLT) $(SLIDES) $<

clean:
	rm -f *.html
