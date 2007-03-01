include ../../../buildtools/Makefile.incl
SLIDES=../source/slides.xml

index.html: ../../xsl/html/default.xsl

	$(XSLT) $(SLIDES) $<

clean:
	rm -f *.html
