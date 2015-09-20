include ../../../buildtools/Makefile.incl
SLIDES=../source/slides.xml

index.html: ../../xsl/html/plain.xsl

	$(XSLT) $(SLIDES) $<

clean:
	rm -f *.html
