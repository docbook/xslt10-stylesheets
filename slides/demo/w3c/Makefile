include ../../../buildtools/Makefile.incl
SLIDES=../source/slides.xml

index.html: ../../xsl/html/w3c.xsl

	$(XSLT) $(SLIDES) $<

clean:
	rm -f *.html
